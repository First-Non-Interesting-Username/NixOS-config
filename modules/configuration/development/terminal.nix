{self, ...}: {
  flake = {
    nixosModules.terminal = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/foot"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        programs.foot = {
          enable = true;
          settings = {
            csd = {
              size = 0;
            };
            scrollback = {
              multiplier = 5.0;
            };
            bell = {
              urgent = false;
              notify = false;
              visual = false;
            };
            cursor = {
              style = "beam";
              blink = true;
              blink-rate = 15000;
            };
          };
        };
      };
    };
  };
}
