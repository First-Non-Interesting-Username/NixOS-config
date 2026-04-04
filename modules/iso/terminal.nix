{self, ...}: {
  flake = {
    nixosModules.iso-terminal = {modulesPath, ...}: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
        self.nixosModules.iso
      ];
    };
  };
}
