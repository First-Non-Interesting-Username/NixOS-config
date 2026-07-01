{self, ...}: {
  flake = {
    nixosModules.GNOME = {
      lib,
      config,
      pkgs,
      ...
    }: {
      imports = [
        # self.nixosModules.vicinae
        self.nixosModules.wayland
      ];

      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          directories = [
            "/var/lib/gdm"
          ];
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/keyrings"
              ".local/share/recently-used"
              ".local/share/nautilus"
              ".config/goa-1.0"
              ".cache/tracker3"
            ];
            files = [
              ".local/share/recently-used.xbel"
            ];
          };
        };
      };

      programs = {
        ssh.startAgent = lib.mkForce false;
        dconf.enable = true;
      };

      services = {
        xserver.enable = true;
        desktopManager.gnome.enable = true;
        displayManager.gdm.enable = true;
      };

      stylix.targets = {
        gnome.enable = true;
      };
      environment.gnome.excludePackages = with pkgs; [
        gnome-tour
        orca
        snapshot
        yelp
        gnome-software
        aisleriot
        atomix
        five-or-more
        four-in-a-row
        gnome-2048
        gnome-klotski
        gnome-mahjongg
        gnome-nibbles
        gnome-robots
        gnome-sudoku
        gnome-taquin
        gnome-tetravex
        hitori
        iagno
        lightsoff
        quadrapassel
        swell-foop
        tali
        dconf-editor
        devhelp
        d-spy
        gnome-builder
        sysprof
        gnome-user-docs
        epiphany
      ];

      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.xdg-desktop-portal-gnome
        ];
      };

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        home.packages = with pkgs; [
          mission-center
        ];

        stylix.targets = {
          gnome.colors.enable = false;
          gtk.colors.enable = false;
        };

        programs = {
          gnome-shell = {
            enable = true;

            extensions = map (pkg: {package = pkg;}) (
              with pkgs.gnomeExtensions; [
                appindicator
                blur-my-shell
                clipboard-indicator
                forge
                just-perfection
                caffeine
                dash-to-dock
                gsconnect
                launch-new-instance
                logo-menu
                search-light
                vitals
                vicinae
                hide-cursor
                gradia-capture
              ]
            );
          };
        };

        dconf = {
          enable = true;
          settings = {
            "org/gnome/desktop/input-sources" = {
              current = 0;
              sources = [
                [
                  "xkb"
                  "pl"
                ]
              ];
              xkb-options = ["caps:swapescape"];
            };
            "org/gnome/desktop/interface" = {
              clock-format = "24h";
              color-scheme = "prefer-dark";
              cursor-theme = "Bibata-Modern-Ice";
              enable-animations = true;
              enable-hot-corners = true;
              gtk-enable-primary-paste = false;
              gtk-key-theme = "Default";
              accent-color = "slate";
              show-battery-percentage = "true";
            };
            "org/gnome/desktop/peripherals/keyboard" = {
              numlock-state = false;
            };
            "org/gnome/desktop/peripherals/mouse" = {
              natural-scroll = true;
              speed = 0.0;
            };
            "org/gnome/desktop/peripherals/touchpad" = {
              two-finger-scrolling-enabled = true;
              tap-to-click = true;
            };
            "org/gnome/desktop/privacy" = {
              report-technical-problems = true;
            };
            "org/gnome/desktop/wm/preferences" = {
              button-layout = "appmenu:minimize,maximize,close";
              resize-with-right-button = true;
              focus-mode = "sloppy";
              auto-raise = false;
            };
            "org/gnome/desktop/wm/keybindings" = {
              switch-to-workspace-1 = ["<Super>1"];
              switch-to-workspace-2 = ["<Super>2"];
              switch-to-workspace-3 = ["<Super>3"];
              switch-to-workspace-4 = ["<Super>4"];
              move-to-workspace-1 = ["<Super><Shift>1"];
              move-to-workspace-2 = ["<Super><Shift>2"];
              move-to-workspace-3 = ["<Super><Shift>3"];
              move-to-workspace-4 = ["<Super><Shift>4"];
              show-desktop = ["<Super>d"];
              close = ["<Super>q"];
              switch-input-source = [];
              switch-input-source-backward = [];
              activate-window-menu = ["<Alt><Super>space"];
              minimize = ["<Super>g"];
              move-to-workspace-left = [];
              move-to-workspace-right = [];
              move-to-monitor-left = [];
              move-to-monitor-right = [];
              move-to-monitor-up = [];
              move-to-monitor-down = [];
            };
            "org/gnome/login-screen" = {
              enable-fingerprint-authentication = true;
              enable-smartcard-authentication = false;
            };
            "org/gnome/mutter" = {
              edge-tiling = false;
              overlay-key = "Super_L";
              experimental-features = ["scale-monitor-framebuffer"];
            };
            "org/gnome/mutter/keybindings" = {
              toggle-tiled-left = [];
              toggle-tiled-right = [];
            };
            "org/gnome/mutter/wayland/keybindings" = {
              restore-shortcuts = [];
            };
            "org/gnome/nautilus/preferences" = {
              default-folder-viewer = "icon-view";
              migrated-gtk-settings = true;
              search-filter-time-type = "last_modified";
              show-create-link = true;
            };
            "org/gnome/shell" = {
              favorite-apps = [
                "firefox.desktop"
                "foot.desktop"
                "org.gnome.Nautilus.desktop"
              ];
            };
            "org/gnome/shell/extensions/Logo-menu" = {
              hide-forcequit = true;
              menu-button-icon-image = 23;
              menu-button-icon-size = 20;
              menu-button-system-monitor = "${pkgs.mission-center}/bin/missioncenter";
              menu-button-terminal = "${pkgs.foot}/bin/foot";
              show-activities-button = true;
              show-gamemode = true;
              show-lockscreen = true;
              show-power-option = false;
              show-power-options = true;
              symbolic-icon = true;
              use-custom-icon = false;
              hide-softwarecentre = false;
            };
            "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
              brightness = 0.6;
              sigma = 30;
            };
            "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
              blur = true;
              brightness = 0.6;
              sigma = 30;
              static-blur = true;
              style-dash-to-dock = 0;
            };
            "org/gnome/shell/extensions/blur-my-shell/panel" = {
              brightness = 0.6;
              sigma = 30;
            };
            "org/gnome/shell/extensions/blur-my-shell/window-list" = {
              brightness = 0.6;
              sigma = 30;
            };
            "org/gnome/shell/extensions/caffeine" = {
              indicator-position-max = 2;
            };
            "org/gnome/shell/extensions/clipboard-indicator" = {
              history-size = 200;
              toggle-menu = ["<Super>b"];
            };
            "org/gnome/shell/extensions/vitals" = {
              position-in-panel = 0;
            };
            "org/gnome/shell/extensions/dash-to-dock" = {
              background-opacity = 0.8;
              click-action = "launch";
              custom-background-color = false;
              dash-max-icon-size = 48;
              dock-fixed = false;
              dock-position = "BOTTOM";
              height-fraction = 0.9;
              hot-keys = false;
              intellihide-mode = "ALL_WINDOWS";
              middle-click-action = "launch";
              preferred-monitor = -2;
              preferred-monitor-by-connector = "DP-2";
              scroll-action = "switch-workspace";
              shift-click-action = "minimize";
              shift-middle-click-action = "launch";
            };
            "org/gnome/shell/extensions/forge" = {
              css-last-update = 37;
              focus-border-toggle = true;
              focus-on-hover-enabled = false;
              move-pointer-focus-enabled = true;
              preview-hint-enabled = true;
              tiling-mode-enabled = true;
              window-gap-hidden-on-single = true;
              window-gap-size-increment = 1;
              dnd-center-layout = "swap";
              stacked-tiling-mode-enabled = false;
              tabbed-tiling-mode-enabled = false;
            };
            "org/gnome/shell/extensions/gsconnect" = {
              devices = [];
              enabled = true;
              missing-openssl = false;
            };
            "org/gnome/shell/extensions/search-light" = {
              animation-speed = 100.0;
              background-color = [
                0.0
                0.0
                0.0
                0.8
              ];
              blur-background = false;
              blur-brightness = 0.6;
              blur-sigma = 30.0;
              border-color = [
                0.0
                0.0
                0.0
                1.0
              ];
              border-radius = 1.65;
              border-thickness = 1;
              entry-font-size = 1;
              monitor-count = 1;
              popup-at-cursor-monitor = false;
              preferred-monitor = 0;
              scale-height = 0.15;
              scale-width = 0.1;
              shortcut-search = ["<Alt>space"];
              show-panel-icon = true;
            };
            "org/gnome/shell/weather" = {
              automatic-location = true;
              locations = [];
            };
            "org/gnome/shell/world-clocks" = {
              locations = [];
            };
            "org/gnome/system/location" = {
              enabled = true;
            };
            "org/gnome/tweaks" = {
              show-extensions-notice = false;
            };
            "org/gtk/gtk4/settings/file-chooser" = {
              show-hidden = true;
              sort-directories-first = true;
            };
            "org/gtk/settings/file-chooser" = {
              clock-format = "24h";
              date-format = "regular";
              location-mode = "path-bar";
              show-hidden = true;
              show-size-column = true;
              show-type-column = true;
              sort-column = "name";
              sort-directories-first = true;
              sort-order = "ascending";
              type-format = "category";
            };
            "org/gnome/shell/keybindings" = {
              screenshot = [];
              show-screenshot-ui = ["<Shift>Print"];
            };
            "org/gnome/settings-daemon/plugins/media-keys" = {
              screensaver = ["<Super>p"];
            };
            "org/gnome/shell/extensions/just-perfection" = {
              support-notifier-type = 0;
            };
            "org/gnome/shell/extensions/forge/keybindings" = {
              focus-center = [];
              window-focus-left = [
                "<Super>h"
                "<Super>Left"
              ];
              window-focus-down = [
                "<Super>j"
                "<Super>Down"
              ];
              window-focus-up = [
                "<Super>k"
                "<Super>Up"
              ];
              window-focus-right = [
                "<Super>l"
                "<Super>Right"
              ];

              window-swap-left = [
                "<Super><Control>h"
                "<Super><Control>Left"
              ];
              window-swap-down = [
                "<Super><Control>j"
                "<Super><Control>Down"
              ];
              window-swap-up = [
                "<Super><Control>k"
                "<Super><Control>Up"
              ];
              window-swap-right = [
                "<Super><Control>l"
                "<Super><Control>Right"
              ];
              window-resize-left-increase = [
                "<Super><Shift>Left"
                "<Super><Shift>h"
              ];
              window-resize-left-decrease = [
                "<Super><Shift><Control>Right"
                "<Super><Shift><Control>l"
              ];

              window-resize-right-increase = [
                "<Super><Shift>Right"
                "<Super><Shift>l"
              ];
              window-resize-right-decrease = [
                "<Super><Shift><Control>Left"
                "<Super><Shift><Control>h"
              ];

              window-resize-top-increase = [
                "<Super><Shift>Up"
                "<Super><Shift>k"
              ];
              window-resize-top-decrease = [
                "<Super><Shift><Control>Down"
                "<Super><Shift><Control>j"
              ];

              window-resize-bottom-increase = [
                "<Super><Shift>Down"
                "<Super><Shift>j"
              ];
              window-resize-bottom-decrease = [
                "<Super><Shift><Control>Up"
                "<Super><Shift><Control>k"
              ];

              workspace-active-tile-toggle = [];

              con-split-horizontal = [];
              con-split-layout-toggle = [];
              con-split-vertical = [];
              con-stacked-layout-toggle = [];
              con-tabbed-layout-toggle = [];
              con-tabbed-showtab-decoration-toggle = [];

              window-snap-center = [];
              window-snap-one-third-left = [];
              window-snap-one-third-right = [];
              window-snap-two-third-left = [];
              window-snap-two-third-right = [];

              window-swap-last-active = [
                "<Super><Shift>Return"
              ];

              window-toggle-always-float = [];

              window-toggle-float = [
                "<Super>c"
              ];
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
              binding = "<Super>Return";
              command = "${pkgs.foot}/bin/foot";
              name = "Terminal";
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files" = {
              binding = "<Super>e";
              command = "xdg-open .";
              name = "File Manager";
            };
            "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae" = {
              binding = "<Super>space";
              command = "vicinae toggle";
              name = "Vicinae";
            };
            "org/gnome/settings-daemon/plugins/media-keys" = {
              custom-keybindings = [
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files/"
                "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae/"
              ];
            };
          };
        };
      };
    };
  };
}
