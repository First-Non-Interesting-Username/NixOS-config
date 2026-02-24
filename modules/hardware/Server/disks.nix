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
      ...
    }: {
      imports = [
        inputs.disko.nixosModules.disko
        ./_disko.nix
      ];

      boot = {
        kernelParams = ["nohibernate"];
        supportedFilesystems = ["zfs"];
        zfs = {
          forceImportRoot = false;
          devNodes = "/dev/disk/by-id";
          extraPools = [
            "data"
            "storage"
          ];
        };
      };

      services.zfs = {
        autoSnapshot.enable = false;

        autoScrub = {
          enable = true;
          interval = "monthly";
        };
      };
    };
  };
}
