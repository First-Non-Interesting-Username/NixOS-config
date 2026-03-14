{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-config = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services = {
        xserver.enable = true;
        desktopManager.plasma6.enable = true;
      };
    };
    homeModules.plasma-config = {
      pkgs,
      lib,
      config,
      ...
    }: let
      fonts = config.stylix.fonts;
    in {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      programs.plasma = {
        enable = true;

        workspace = {
          wallpaper = toString config.stylix.image;
          cursor = {
            theme = config.stylix.cursor.name;
            size = config.stylix.cursor.size;
          };
        };

        fonts = {
          general = {
            family = fonts.sansSerif.name;
            pointSize = fonts.sizes.applications;
          };
          fixedWidth = {
            family = fonts.monospace.name;
            pointSize = fonts.sizes.terminal;
          };
          small = {
            family = fonts.sansSerif.name;
            pointSize = fonts.sizes.desktop;
          };
          toolbar = {
            family = fonts.sansSerif.name;
            pointSize = fonts.sizes.applications;
          };
          menu = {
            family = fonts.sansSerif.name;
            pointSize = fonts.sizes.applications;
          };
          windowTitle = {
            family = fonts.sansSerif.name;
            pointSize = fonts.sizes.applications;
          };
        };

        workspace.iconStyle = config.stylix.icons.dark;
      };
    };
  };
}
