_: {
  flake = {
    nixosModules.power = _: {
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
      };
    };
  };
}
