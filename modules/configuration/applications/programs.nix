_: {
  flake = {
    nixosModules.programs-desktop = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          directories = [
            "/var/lib/kdeconnect"
          ];
          files = [
            # System-level files to persist
          ];
          users.${config.custom.user.name} = {
            directories = [
              ".config/kdeconnect"
            ];
            files = [
              # User-level files to persist (relative to $HOME)
            ];
          };
        };
      };

      programs = {
        kdeconnect.enable = true;
      };

      home-manager.users.${config.custom.user.name} = _: {
      };
    };
  };
}
