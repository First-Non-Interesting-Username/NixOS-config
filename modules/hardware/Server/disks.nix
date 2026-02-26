{
  self,
  inputs,
  username,
  ...
}:
{
  flake = {
    nixosModules.disks-Server =
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
          kernelParams = [ "nohibernate" ];
          supportedFilesystems = [ "zfs" ];
          zfs = {
            forceImportRoot = false;
            devNodes = "/dev/disk/by-id";
            extraPools = [
              "data"
              "storage"
            ];
          };
        };

        systemd.tmpfiles.rules = [
          "d /mnt/data    0755 ${username} users -"
          "d /mnt/storage 0755 ${username} users -"
        ];

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
