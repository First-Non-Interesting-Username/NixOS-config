{self, ...}: {
  flake = {
    nixosModules.hyprland = {...}: {
      nix.settings = {
        extra-substituters = ["https://hyprland.cachix.org"];
        extra-trusted-public-keys = [
          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        ];
      };

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
