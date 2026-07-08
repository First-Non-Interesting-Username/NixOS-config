{
  flake = {
    nixosModules.DE-programs-gnome = { lib, config, ... }:
    let
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
      fg_bg = { Foreground = c.base05; Background = c.base00; };
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
        home-manager.users.${config.custom.user.name} = { pkgs, ... }: lib.mkMerge [
          (lib.mkIf (cfg.fileManager == "gnome") {
            home.packages = [ pkgs.nautilus ];
            # You can add arbitrary settings here! Example:
            # dconf.settings."org/gnome/nautilus/preferences".default-folder-viewer = "icon-view";
          })

          (lib.mkIf (cfg.documentViewer == "gnome") {
            home.packages = [ pkgs.papers ];
          })

          (lib.mkIf (cfg.archiveTool == "gnome") {
            home.packages = [ pkgs.file-roller ];
          })

          (lib.mkIf (cfg.screenshotUtility == "gnome") {
            home.packages = [ pkgs.kooha pkgs.gradia ];
          })

          (lib.mkIf (cfg.systemMonitor == "gnome") {
            home.packages = [ pkgs.mission-center ];
          })

          (lib.mkIf (cfg.textEditor == "gnome") {
            home.packages = [ pkgs.gnome-text-editor ];
          })

          (lib.mkIf (cfg.imageViewer == "gnome") {
            home.packages = [ pkgs.loupe ];
          })

          (lib.mkIf (cfg.paintingApp == "gnome") {
            home.packages = [ pkgs.pinta ];
          })

          (lib.mkIf (cfg.calculator == "gnome") {
            home.packages = [ pkgs.gnome-calculator ];
          })

          (lib.mkIf (cfg.characterSelector == "gnome") {
            home.packages = [ pkgs.gnome-characters ];
          })

          (lib.mkIf (cfg.isoWriter == "gnome") {
            home.packages = [ pkgs.impression ];
          })

          (lib.mkIf (cfg.diskUsageViewer == "gnome") {
            home.packages = [ pkgs.baobab ];
          })

          (lib.mkIf (cfg.musicPlayer == "gnome") {
            home.packages = [ pkgs.gnome-music ];
          })

          (lib.mkIf (cfg.matrixClient == "gnome") {
            home.packages = [ pkgs.fractal ];
          })

          (lib.mkIf (cfg.calendar == "gnome") {
            home.packages = [ pkgs.gnome-calendar ];
          })

          (lib.mkIf (cfg.chess == "gnome") {
            home.packages = [ pkgs.gnome-chess ];
          })

          (lib.mkIf (cfg.whiteboard == "gnome") {
            home.packages = [ pkgs.rnote ];
          })

          (lib.mkIf (cfg.clock == "gnome") {
            home.packages = [ pkgs.gnome-clocks ];
          })

          (lib.mkIf (cfg.terminalEmulator == "gnome") {
            programs.ptyxis = {
              palettes.stylix = {
                Palette.Name = "Stylix";
                Light = palette;
                Dark = palette;
              };
              enable = true;
            };
            dconf.settings = {
              "org/gnome/Ptyxis" = {
                default-profile-uuid = "00000000-0000-0000-0000-000000000000";
                restore-session = true;
                restore-window-size = true;
                profile-uuids = [
                  "00000000-0000-0000-0000-000000000000"
                ]; };
                "org/gnome/Ptyxis/Profiles/00000000-0000-0000-0000-000000000000" = {
                  palette = "Stylix";
                };
              };
            };
          })
        ];
      };
    };
  };
}
