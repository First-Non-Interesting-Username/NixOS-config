{...}: {
  flake = {
    nixosModules.programs-desktop = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [
            "/var/lib/kdeconnect"
          ];
          files = [
            # System-level files to persist
          ];
          users.${username} = {
            directories = [
              ".config/kdeconnect"
              ".config/obsidian"
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

      home-manager.users.${username} = {...}: {
        programs = {
          obsidian = {
            enable = true;
          };
        };
      };
    };
  };
}
