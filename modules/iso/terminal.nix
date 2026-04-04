{ self, ... }:
{
  flake = {
    nixosModules.iso-terminal =
      {
        pkgs,
        modulesPath,
        username,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
          self.nixosModules.iso
        ];
      };
  };
}
