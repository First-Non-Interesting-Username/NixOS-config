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
      ...
    }: {
      programs.kdeconnect.enable = true;

      environment.persistence."/persist" =
        lib.mkIf
        (
          config ? environment
          && config.environment ? persistence
          && config.environment.persistence ? "/persist"
        )
        {
          directories = [
            "/var/lib/kdeconnect"
          ];
          files = [
            # System-level files to persist
          ];
          users.${username}.directories = [
            ".config/kdeconnect"
          ];
          users.${username}.files = [
            # User-level files to persist (relative to $HOME)
          ];
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
