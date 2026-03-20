{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-other = {
      pkgs,
      lib,
      config,
      options,
      username,
      ...
    }: {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
      };
      environment.persistence."/persist" =
        lib.mkIf (options ? environment && options.environment ? persistence)
        {
          directories = [
            "/var/lib/sddm"
          ];
          files = [
            # System-level files to persist
          ];
          users.${username} = {
            directories = [
              ".local/share/kactivitymanagerd"
              ".local/share/kscreen"
              ".local/share/kwalletd"
            ];
            files = [
            ];
          };
        };
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        ...
      }: {
        # Home config goes here
      };
    };
  };
}
