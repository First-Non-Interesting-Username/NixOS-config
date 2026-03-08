{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.disks-Server = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_disko.nix
      ];

      boot = {
        supportedFilesystems = [
          "btrfs"
          "xfs"
        ];
      };

      systemd.tmpfiles.rules = [
        "d /mnt/data    0755 ${username} users -"
        "d /mnt/storage 0755 ${username} users -"
      ];

      services = {
        btrfs.autoScrub = {
          enable = true;
          fileSystems = ["/"];
          interval = "monthly";
        };
        udev.extraRules = ''
          ACTION=="add|change", KERNEL=="sdc", ATTR{queue/scheduler}="bfq"
        '';
      };
    };
  };
}
