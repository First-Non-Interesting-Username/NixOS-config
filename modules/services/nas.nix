{...}: {
  flake = {
    nixosModules.nas-server = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports =
        []
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/nfs"
            ];
          };
        };

      services.nfs.server = {
        enable = true;
        fixedPorts = true;
        exports = ''
          /mnt/storage  192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
        '';
      };
      networking.firewall = {
        allowedTCPPorts = [111 2049];
        allowedUDPPorts = [111 2049];
      };
    };
    nixosModules.nas-client = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports =
        []
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/nfs"
            ];
          };
        };

      boot.supportedFilesystems = ["nfs"];
      fileSystems."/mnt/storage" = {
        device = "192.168.0.10:/mnt/storage";
        fsType = "nfs";
        options = [
          "x-systemd-automount"
          "noauto"
          "x-systemd.idle-timeout=600"
          "rw"
        ];
      };
    };
  };
}
