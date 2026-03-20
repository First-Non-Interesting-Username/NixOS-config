{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        self.nixosModules.hyprland-apps
        self.nixosModules.hyprland-config
        self.nixosModules.hyprland-dm
        self.nixosModules.hyprland-other
        self.nixosModules.noctalia
      ];
    };
  };
}
