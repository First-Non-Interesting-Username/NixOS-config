{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.disks-Minimal =
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
        };
      };
  };
}
