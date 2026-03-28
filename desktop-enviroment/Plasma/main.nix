{self, ...}: {
  flake = {
    nixosModules.plasma = {...}: {
      imports = [
        self.nixosModules.plasma-apps
        self.nixosModules.plasma-config
        self.nixosModules.plasma-dm
        self.nixosModules.plasma-other
      ];
    };
  };
}
