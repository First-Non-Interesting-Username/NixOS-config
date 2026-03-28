_: {
  flake = {
    nixosModules.hyprland-dm = _: {
      programs.regreet.enable = true;
    };
  };
}
