{...}: {
  flake = {
    nixosModules.power = {...}: {
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
      };
    };
  };
}
