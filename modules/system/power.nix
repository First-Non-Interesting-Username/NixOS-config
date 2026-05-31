_: {
  flake = {
    nixosModules.power = {
      lib,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [
            "/var/lib/power-profiles-daemon"
          ];
        };
      };

      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
      };
    };
  };
}
