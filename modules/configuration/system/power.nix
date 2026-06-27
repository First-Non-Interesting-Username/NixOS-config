_: {
  flake = {
    nixosModules.power = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          directories = [
            "/var/lib/power-profiles-daemon"
          ];
        };
      };

      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
        # Here, because it helps to reduce power usage
        irqbalance.enable = true;
      };
    };
  };
}
