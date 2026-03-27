{...}: {
  flake = {
    nixosModules.hyprland-dm = {...}: {
      programs.regreet.enable = true;
    };
  };
}
