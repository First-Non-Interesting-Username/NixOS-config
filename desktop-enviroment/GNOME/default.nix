{ self, ... }:
{
  flake = {
    nixosModules.GNOME =
      {
        lib,
        username,
        impermanence,
        pkgs,
        ...
      }:
      {
        imports = [
          self.nixosModules.vicinae
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/gdm"
            ];
            users.${username} = {
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

        programs.ssh.startAgent = lib.mkForce false;

        services = {
          xserver.enable = true;
          desktopManager.gnome.enable = true;
          displayManager.gdm = {
            enable = true;
            wayland = true;
          };
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

        home-manager.users.${username} = _: {
          home.packages = with pkgs; [
            mission-center
            wmctrl
          ];

          stylix.targets = {
            gnome.colors.enable = false;
            gtk.colors.enable = false;
          };

          programs = {
            gnome-shell = {
              enable = true;

              extensions = map (pkg: { package = pkg; }) (
                with pkgs.gnomeExtensions;
                [
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
                ]
              );
            };
          };

          dconf = {
            settings = {
              "org/gnome/desktop/input-sources" = {
                current = 0;
                sources = [
                  [
                    "xkb"
                    "pl"
                  ]
                ];
                xkb-options = [ "caps:swapescape" ];
              };
              "org/gnome/desktop/interface" = {
                clock-format = "24h";
                color-scheme = "prefer-dark";
                cursor-theme = "Bibata-Modern-Ice";
                enable-animations = true;
                enable-hot-corners = true;
                gtk-enable-primary-paste = false;
                gtk-key-theme = "Default";
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
              };
              "org/gnome/desktop/privacy" = {
                report-technical-problems = true;
              };
              "org/gnome/desktop/wm/preferences" = {
                button-layout = "appmenu:minimize,maximize,close";
                resize-with-right-button = true;
              };
              "org/gnome/login-screen" = {
                enable-fingerprint-authentication = true;
                enable-smartcard-authentication = false;
              };
              "org/gnome/mutter" = {
                edge-tiling = false;
                overlay-key = "Super_L";
              };
              "org/gnome/mutter/keybindings" = {
                toggle-tiled-left = [ ];
                toggle-tiled-right = [ ];
              };
              "org/gnome/mutter/wayland/keybindings" = {
                restore-shortcuts = [ ];
              };
              "org/gnome/nautilus/preferences" = {
                default-folder-viewer = "icon-view";
                migrated-gtk-settings = true;
                search-filter-time-type = "last_modified";
                show-create-link = true;
              };
              "org/gnome/shell" = {
                favorite-apps = [
                  "floorp.desktop"
                  "foot.desktop"
                  "org.gnome.Nautilus.desktop"
                ];
              };
              "org/gnome/shell/extensions/Logo-menu" = {
                hide-forcequit = true;
                menu-button-icon-image = 30;
                menu-button-icon-size = 20;
                menu-button-system-monitor = "/usr/bin/missioncenter-helper";
                menu-button-terminal = "xdg-terminal-exec";
                show-activities-button = true;
                show-gamemode = true;
                show-lockscreen = true;
                show-power-option = false;
                show-power-options = true;
                symbolic-icon = true;
                use-custom-icon = false;
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
                focus-border-toggle = false;
                focus-on-hover-enabled = true;
                move-pointer-focus-enabled = true;
                preview-hint-enabled = true;
                tiling-mode-enabled = false;
                window-gap-hidden-on-single = true;
                window-gap-size-increment = 1;
              };
              "org/gnome/shell/extensions/gsconnect" = {
                devices = [ ];
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
                  0.23
                  0.23
                  0.23
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
                shortcut-search = [ "<Alt>space" ];
                show-panel-icon = true;
              };
              "org/gnome/shell/weather" = {
                automatic-location = true;
                locations = [ ];
              };
              "org/gnome/shell/world-clocks" = {
                locations = [ ];
              };
              "org/gnome/system/location" = {
                enabled = true;
              };
              "org/gnome/tweaks" = {
                show-extensions-notice = false;
              };
              "org/gtk/gtk4/settings/color-chooser" = {
                custom-colors = [
                  [
                    1.0
                    1.0
                    1.0
                    0.0
                  ]
                ];
                selected-color = [
                  true
                  1.0
                  1.0
                  1.0
                  0.0
                ];
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
              "org/gnome/shell/extensions/forge/keybindings" = {
                focus-center = [ ];
                focus-down = [
                  "<Super>j"
                  "<Super>Down"
                ];
                focus-left = [
                  "<Super>h"
                  "<Super>Left"
                ];
                focus-right = [
                  "<Super>l"
                  "<Super>Right"
                ];
                focus-up = [
                  "<Super>k"
                  "<Super>Up"
                ];
                swap-down = [
                  "<Super><Ctrl>j"
                  "<Super><Ctrl>Down"
                ];
                swap-left = [
                  "<Super><Ctrl>h"
                  "<Super><Ctrl>Left"
                ];
                swap-right = [
                  "<Super><Ctrl>l"
                  "<Super><Ctrl>Right"
                ];
                swap-up = [
                  "<Super><Ctrl>k"
                  "<Super><Ctrl>Up"
                ];
                resize-down = [
                  "<Super><Shift>j"
                  "<Super><Shift>Down"
                ];
                resize-left = [
                  "<Super><Shift>h"
                  "<Super><Shift>Left"
                ];
                resize-right = [
                  "<Super><Shift>l"
                  "<Super><Shift>Right"
                ];
                resize-up = [
                  "<Super><Shift>k"
                  "<Super><Shift>Up"
                ];
                toggle-maximize = [ "<Super>g" ];
                toggle-fullscreen = [ "<Super>f" ];
                close = [ "<Super>q" ];
                snap-down = [ ];
                snap-left = [ ];
                snap-right = [ ];
                snap-up = [ ];
                tile-down = [ ];
                tile-left = [ ];
                tile-right = [ ];
                tile-up = [ ];
                promote = [ ];
                promote-all = [ ];
                restart = [ ];
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal" = {
                binding = "<Super>Return";
                command = "xdg-terminal-exec";
                name = "Terminal";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files" = {
                binding = "<Super>e";
                command = "xdg-open .";
                name = "File Manager";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipboard" = {
                binding = "<Super>b";
                command = "clipboard-indicator";
                name = "Clipboard Manager";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot" = {
                binding = "Shift+Print";
                command = "gnome-screenshot -a";
                name = "Screenshot (area)";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/show-desktop" = {
                binding = "<Super>d";
                command = "wmctrl -k on";
                name = "Show Desktop";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock" = {
                binding = "<Super>l";
                command = "loginctl lock-session";
                name = "Lock";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws1" = {
                binding = "<Super>1";
                command = "wmctrl -s 0";
                name = "Workspace 1";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws2" = {
                binding = "<Super>2";
                command = "wmctrl -s 1";
                name = "Workspace 2";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws3" = {
                binding = "<Super>3";
                command = "wmctrl -s 2";
                name = "Workspace 3";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws4" = {
                binding = "<Super>4";
                command = "wmctrl -s 3";
                name = "Workspace 4";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws5" = {
                binding = "<Super>5";
                command = "wmctrl -s 4";
                name = "Workspace 5";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws6" = {
                binding = "<Super>6";
                command = "wmctrl -s 5";
                name = "Workspace 6";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws7" = {
                binding = "<Super>7";
                command = "wmctrl -s 6";
                name = "Workspace 7";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws8" = {
                binding = "<Super>8";
                command = "wmctrl -s 7";
                name = "Workspace 8";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws9" = {
                binding = "<Super>9";
                command = "wmctrl -s 8";
                name = "Workspace 9";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws10" = {
                binding = "<Super>0";
                command = "wmctrl -s 9";
                name = "Workspace 10";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws1" = {
                binding = "<Super><Shift>1";
                command = "wmctrl -r :ACTIVE: -t 0";
                name = "Move to Workspace 1";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws2" = {
                binding = "<Super><Shift>2";
                command = "wmctrl -r :ACTIVE: -t 1";
                name = "Move to Workspace 2";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws3" = {
                binding = "<Super><Shift>3";
                command = "wmctrl -r :ACTIVE: -t 2";
                name = "Move to Workspace 3";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws4" = {
                binding = "<Super><Shift>4";
                command = "wmctrl -r :ACTIVE: -t 3";
                name = "Move to Workspace 4";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws5" = {
                binding = "<Super><Shift>5";
                command = "wmctrl -r :ACTIVE: -t 4";
                name = "Move to Workspace 5";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws6" = {
                binding = "<Super><Shift>6";
                command = "wmctrl -r :ACTIVE: -t 5";
                name = "Move to Workspace 6";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws7" = {
                binding = "<Super><Shift>7";
                command = "wmctrl -r :ACTIVE: -t 6";
                name = "Move to Workspace 7";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws8" = {
                binding = "<Super><Shift>8";
                command = "wmctrl -r :ACTIVE: -t 7";
                name = "Move to Workspace 8";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws9" = {
                binding = "<Super><Shift>9";
                command = "wmctrl -r :ACTIVE: -t 8";
                name = "Move to Workspace 9";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws10" = {
                binding = "<Super><Shift>0";
                command = "wmctrl -r :ACTIVE: -t 9";
                name = "Move to Workspace 10";
              };
              "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae" = {
                binding = "<Super>space";
                command = "vicinae";
                name = "Vicinae";
              };
              "org/gnome/settings-daemon/plugins/media-keys" = {
                custom-keybindings = [
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/terminal/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/files/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/clipboard/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/screenshot/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/show-desktop/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/lock/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws1/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws2/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws3/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws4/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws5/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws6/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws7/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws8/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws9/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/ws10/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws1/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws2/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws3/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws4/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws5/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws6/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws7/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws8/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws9/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/move-ws10/"
                  "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/vicinae/"
                ];
              };
            };
          };
        };
      };
  };
}
