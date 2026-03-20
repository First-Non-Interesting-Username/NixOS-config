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
  };
}
