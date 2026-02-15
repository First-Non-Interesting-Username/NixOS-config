{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        self.nixosModules.plasma-apps
        self.nixosModules.plasma-config
        self.nixosModules.plasma-dm
        self.nixosModules.plasma-other
      ];
    };
    homeModules.plasma = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        self.homeModules.plasma-apps
        self.homeModules.plasma-config
        self.homeModules.plasma-other
      ];
    };
  };
}
