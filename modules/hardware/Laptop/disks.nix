{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.disks-Laptop =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        imports = [
          inputs.disko.nixosModules.disko
          ./_disko.nix
        ];

        boot = {
          supportedFilesystems = [ "zfs" ];
          zfs = {
            devNodes = "/dev/disk/by-id";
            forceImportRoot = false;
          };
          kernelParams = [ "nohibernate" ];
        };

        services.zfs = {
          autoSnapshot.enable = false;

          autoScrub = {
            enable = true;
            interval = "monthly";
          };
        };

        fileSystems = {
          "/" = {
            neededForBoot = true;
          };

          "/nix" = {
            neededForBoot = true;
          };

          "/persist" = {
            neededForBoot = true;
          };

          "/etc" = {
            depends = [
              "/"
              "/persist"
            ];
            neededForBoot = true;
          };
          "/home" = {
            depends = [
              "/"
              "/persist"
            ];
            neededForBoot = true;
          };
          "/var" = {
            depends = [
              "/"
              "/persist"
            ];
            neededForBoot = true;
          };
          "/var/lib" = {
            depends = [
              "/"
              "/persist"
            ];
            neededForBoot = true;
          };
        };
      };
  };
}
