_: {
  flake = {
    nixosModules.DE-programs-gnome = {
      lib,
      config,
      ...
    }: let
      cfg = config.custom.DE.programs;

      c = config.lib.stylix.colors.withHashtag;
      normal = {
        Color0 = c.base00;
        Color1 = c.base08;
        Color2 = c.base0B;
        Color3 = c.base0A;
        Color4 = c.base0D;
        Color5 = c.base0E;
        Color6 = c.base0C;
        Color7 = c.base05;
      };

      bright = {
        Color8 = c.base03;
        Color9 = c.base08;
        Color10 = c.base0B;
        Color11 = c.base0A;
        Color12 = c.base0D;
        Color13 = c.base0E;
        Color14 = c.base0C;
        Color15 = c.base07;
      };

      fg_bg = {
        Foreground = c.base05;
        Background = c.base00;
      };

      status = {
        BellForeground = c.base00;
        BellBackground = c.base0A;
        RemoteForeground = c.base05;
        RemoteBackground = c.base0D;
        SuperuserForeground = c.base00;
        SuperuserBackground = c.base08;
      };

      palette = fg_bg // normal // bright // status;
    in {
      config = lib.mkIf config.custom.DE.enable {
        home-manager.users.${config.custom.user.name} = {pkgs, ...}:
          lib.mkMerge [
            {
              home.packages = lib.mkMerge [
                (lib.mkIf (cfg.fileManager == "gnome") [pkgs.nautilus])
                (lib.mkIf (cfg.documentViewer == "gnome") [pkgs.papers])
                (lib.mkIf (cfg.archiveTool == "gnome") [pkgs.file-roller])
                (lib.mkIf (cfg.screenshotUtility == "gnome") [pkgs.kooha pkgs.gradia])
                (lib.mkIf (cfg.systemMonitor == "gnome") [pkgs.mission-center])
                (lib.mkIf (cfg.textEditor == "gnome") [pkgs.gnome-text-editor])
                (lib.mkIf (cfg.imageViewer == "gnome") [pkgs.loupe])
                (lib.mkIf (cfg.paintingApp == "gnome") [pkgs.pinta])
                (lib.mkIf (cfg.calculator == "gnome") [pkgs.gnome-calculator])
                (lib.mkIf (cfg.characterSelector == "gnome") [pkgs.gnome-characters])
                (lib.mkIf (cfg.isoWriter == "gnome") [pkgs.impression])
                (lib.mkIf (cfg.diskUsageViewer == "gnome") [pkgs.baobab])
                (lib.mkIf (cfg.musicPlayer == "gnome") [pkgs.gnome-music])
                (lib.mkIf (cfg.matrixClient == "gnome") [pkgs.fractal])
                (lib.mkIf (cfg.calendar == "gnome") [pkgs.gnome-calendar])
                (lib.mkIf (cfg.chess == "gnome") [pkgs.gnome-chess])
                (lib.mkIf (cfg.whiteboard == "gnome") [pkgs.rnote])
                (lib.mkIf (cfg.clock == "gnome") [pkgs.gnome-clocks])
              ];

              programs = lib.mkMerge [
                (lib.mkIf (cfg.terminalEmulator == "gnome") {
                  ptyxis = {
                    palettes = {
                      stylix = {
                        Palette.Name = "Stylix";

                        Light = palette;
                        Dark = palette;
                      };
                    };
                    enable = true;
                  };
                })
              ];
            }
          ];
      };
    };
  };
}
