{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland-apps = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
        brightnessctl
      ];
    };
    homeModules.hyprland-apps = {
      pkgs,
      lib,
      config,
      vicinae,
      ...
    }: {
      imports = [
        vicinae.homeManagerModules.default
      ];

      home.packages = with pkgs; [
        swayimg
        grimblast
        slurp
        playerctl
        wl-clipboard
        pavucontrol
        hyprnome
        wireplumber
        brightnessctl

        kdePackages.dolphin
        kdePackages.kio
        kdePackages.kio-fuse
        kdePackages.kio-extras
        kdePackages.qtwayland
        kdePackages.breeze-icons
        kdePackages.qtsvg
      ];

      programs.swayimg = {
        enable = true;
        settings = {
          viewer = {
            window = "#10000010";
            scale = "fit";
          };
        };
      };

      services = {
        vicinae = {
          enable = true;
          systemd = {
            enable = true;
            autoStart = true;
            environment = {
              USE_LAYER_SHELL = 1;
            };
          };
          settings = {
            close_on_focus_loss = true;
            consider_preedit = true;
            pop_to_root_on_close = true;
            favicon_service = "twenty";
            search_files_in_root = true;
            launcher_window = {
              opacity = 0.98;
            };
          };
          extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
            bluetooth
            nix
            power-profile
            vscode-recents
            ssh
            searxng
            hypr-keybinds
            it-tools
          ];
        };

        hyprpolkitagent.enable = true;
        cliphist = {
          enable = true;
          allowImages = true;
        };
      };
    };
  };
}
