{...}: {
  flake = {
    nixosModules.CHANGEME = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [
            # System-level dirs to persist
          ];
          files = [
            # System-level files to persist
          ];
          users.${username} = {
            directories = [
              # User-level dirs to persist (relative to $HOME)
            ];
            files = [
              # User-level files to persist (relative to $HOME)
            ];
          };
        };
      };

      # System config goes here

      home-manager.users.${username} = _: {
        # Home config goes here
      };
    };
  };
}
