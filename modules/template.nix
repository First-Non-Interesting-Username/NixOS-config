{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.CHANGEME = {
      pkgs,
      lib,
      config,
      options,
      username,
      ...
    }: {
      # System config goes here

      environment.persistence."/persist" =
        lib.mkIf (options ? environment && options.environment ? persistence)
        {
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

    homeModules.CHANGEME = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
