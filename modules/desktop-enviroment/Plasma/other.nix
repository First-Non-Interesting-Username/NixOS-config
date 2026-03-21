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
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
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
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
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
