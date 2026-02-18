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
        resumeDevice = "/dev/zvol/rpool/swap";
        supportedFilesystems = ["zfs"];
        zfs.devNodes = "/dev/disk/by-id";
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
      fileSystems."/etc".neededForBoot = true;
      fileSystems."/home".neededForBoot = true;
      fileSystems."/var".neededForBoot = true;
      fileSystems."/var/lib".neededForBoot = true;
    };
  };
}
