{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.power = {
      pkgs,
      lib,
      config,
      username,
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
