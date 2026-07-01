_: {
  flake = {
    nixosModules.DE-programs = {
      lib,
      config,
      ...
    }: let
      cfg = config.custom.DE.programs;
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
                  ptyxis.enable = true;
                })
              ];
            }
          ];
      };
    };
  };
}
