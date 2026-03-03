{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.programs-desktop = {
      pkgs,
      lib,
      config,
      username,
      options,
      ...
    }: {
      programs.kdeconnect.enable = true;

      environment.persistence."/persist" =
        lib.mkIf (options ? environment && options.environment ? persistence)
        {
          directories = [
            "/var/lib/kdeconnect"
          ];
          files = [
            # System-level files to persist
          ];
          users.${username} = {
            directories = [
              ".config/kdeconnect"
            ];
            files = [
              # User-level files to persist (relative to $HOME)
            ];
          };
        };
    };
    homeModules.programs-desktop = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
