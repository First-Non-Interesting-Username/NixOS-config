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
      ];
    };
    homeModules.hyprland = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        self.homeModules.hyprland-apps
        self.homeModules.hyprland-config
        self.homeModules.hyprland-other
        self.homeModules.noctalia
      ];
    };
  };
}
