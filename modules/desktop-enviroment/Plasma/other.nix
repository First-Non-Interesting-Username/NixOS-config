{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.plasma-other =
      {
        pkgs,
        lib,
        config,
        options,
        username,
        ...
      }:
      {
        xdg.portal = {
          enable = true;
          extraPortals = [
            pkgs.kdePackages.xdg-desktop-portal-kde
          ];
        };
        #system.activationScripts.createPersistFiles = {
        #  text = ''
        #    mkdir -p /persist/home/${username}/.config
        #    for f in kwinrc plasmashellrc plasma-org.kde.plasma.desktop-appletsrc kdeglobals; do
        #      if [ ! -f "/persist/home/${username}/.config/$f" ]; then
        #        touch "/persist/home/${username}/.config/$f"
        #      fi
        #    done
        #  '';
        #};
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
                  #".config/kdeglobals"
                  #".config/plasma-org.kde.plasma.desktop-appletsrc"
                  #".config/plasmashellrc"
                  #".config/kwinrc"
                ];
              };
            };
      };
    homeModules.plasma-other =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        # Home config goes here
      };
  };
}
