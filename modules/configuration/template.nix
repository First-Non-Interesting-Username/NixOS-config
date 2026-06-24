{...}: {
  flake = {
    nixosModules.CHANGEME = {
      lib,
      username,
      impermanence,
      config,
      ...
    }: {
      imports =
        []
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories =
              # Omit that block if you don't plan including any subdirectories of /var/lib
              lib.filter (
                d: let
                  dir =
                    if builtins.isString d
                    then d
                    else d.directory;
                in
                  !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
              ) [
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

      home-manager.users.${username} = {...}: {
        # Home config goes here
      };
    };
  };
}
