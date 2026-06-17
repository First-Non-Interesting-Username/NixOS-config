_: {
  flake = {
    nixosModules.nasServer = {
      lib,
      impermanence,
      config,
      ...
    }: {
      imports =
        []
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories =
              lib.filter (
                d: let
                  dir =
                    if builtins.isString d
                    then d
                    else d.directory;
                in
                  !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
              ) [
                "/var/lib/nfs"
              ];
          };
        };
      };

      services.nfs.server = {
        enable = true;
        lockdPort = 4045;
        mountdPort = 4046;
        statdPort = 4047;
        exports = ''
          /mnt/storage  192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
        '';
      };
      networking.firewall = {
        allowedTCPPorts = [111 2049 4045 4046 4047];
        allowedUDPPorts = [111 2049 4045 4046 4047];
      };
    };
    nixosModules.nasClient = {
      lib,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
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
