{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.plasma = {
      pkgs,
      lib,
      username,
      impermanence,
      ...
    }: {
      imports =
        [
          self.nixosModules.wayland
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/sddm"
            ];
            users.${username} = {
              directories = [
                ".local/share/kactivitymanagerd"
                ".local/share/kscreen"
                ".local/share/kwalletd"
              ];
            };
          };
        };

      services = {
        xserver.enable = true;
        desktopManager.plasma6.enable = true;
        displayManager.sddm = {
          enable = true;
          wayland.enable = true;
          theme = "sddm-astronaut-theme";
          extraPackages = [pkgs.sddm-astronaut];
        };
      };

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
      };

      environment.systemPackages = with pkgs.kdePackages;
        [
          qtstyleplugin-kvantum
        ]
        ++ [pkgs.sddm-astronaut];

      home-manager.users.${username} = {
        pkgs,
        config,
        ...
      }: let
        inherit (config.stylix) fonts;
      in {
        imports = [
          inputs.plasma-manager.homeModules.plasma-manager
        ];

        home.packages = with pkgs.kdePackages; [
          dolphin
          gwenview
          ark
          plasma-systemmonitor
          kcalc
          spectacle
          merkuro
          kclock
          kweather
          kolourpaint
          isoimagewriter
          qtstyleplugin-kvantum
        ];

        programs = {
          kate.enable = true;
          konsole.enable = true;
          okular.enable = true;
          elisa.enable = true;
          plasma = {
            enable = true;

            workspace = {
              iconTheme = config.stylix.icons.dark;
              wallpaper = toString config.stylix.image;
              cursor = {
                theme = config.stylix.cursor.name;
                inherit (config.stylix.cursor) size;
              };
              lookAndFeel = "org.kde.breezedark.desktop";
              colorScheme = "BreezeDark";
            };

            input.keyboard = {
              layouts = [{layout = "pl";}];
              options = ["caps:swapescape"];
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

            krunner = {
              position = "center";
            };

            shortcuts = {
              "plasmashell"."activate application launcher" = [];
              kwin = {
                "Overview" = "Meta";

                "Window Close" = "Meta+Q";

                "Window Fullscreen" = "Meta+F";

                "Switch to Desktop 1" = "Meta+1";
                "Switch to Desktop 2" = "Meta+2";
                "Switch to Desktop 3" = "Meta+3";
                "Switch to Desktop 4" = "Meta+4";
                "Switch to Desktop 5" = "Meta+5";
                "Switch to Desktop 6" = "Meta+6";
                "Switch to Desktop 7" = "Meta+7";
                "Switch to Desktop 8" = "Meta+8";
                "Switch to Desktop 9" = "Meta+9";
                "Switch to Desktop 10" = "Meta+0";
              };

              "org.kde.krunner.desktop" = {
                "_launch" = [
                  "Meta+D"
                  "Meta+Space"
                ];
              };

              "services/kitty.desktop" = {
                "_launch" = "Meta+Return";
              };

              "services/org.kde.dolphin.desktop" = {
                "_launch" = "Meta+E";
              };

              "spectacle" = {
                "RectangularRegionScreenShot" = "Shift+Print";
              };

              "org.kde.klipper.desktop" = {
                "clipboard_action" = "Meta+B";
              };

              "services/hexecute.desktop" = {
                "_launch" = "Meta+G";
              };
            };

            configFile = {
              kwinrc.Plugins.zoomEnabled = false;
              kglobalshortcutsrc."kwin"."Zoom In" = ",,,Zoom In";
              kglobalshortcutsrc."kwin"."Zoom Out" = ",,,Zoom Out";
              kglobalshortcutsrc."kwin"."Zoom to Actual Size" = ",,,Zoom to Actual Size";
            };
          };
        };
      };
    };
  };
}
