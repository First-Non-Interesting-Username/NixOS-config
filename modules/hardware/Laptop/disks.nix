{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.disks-Laptop = {
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
        supportedFilesystems = ["zfs"];
        zfs.devNodes = "/dev/disk/by-id";
        kernelParams = ["nohibernate"];
      };

      services.zfs = {
        autoSnapshot.enable = false;

        autoScrub = {
          enable = true;
          interval = "monthly";
        };
      };

      fileSystems."/persist".neededForBoot = true;
      fileSystems."/".neededForBoot = true;
    };
  };
}
