_: {
  flake = {
    nixosModules.gaming = {
      lib,
      username,
      impermanence,
      pkgs,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".local/share/Steam"
              ".local/share/PrismLauncher"
              ".config/heroic"
              ".config/lutris"
              ".local/share/lutris"
              ".factorio"
            ];
          };
        };
      };

      #nixpkgs.config.factorio = {
      #  username = "Asmusin";
      #  token = config.sops.secrets.factorio_token;
      #};

      sops.secrets.factorio_token = {};

      programs = {
        gamescope.enable = true;
        gamemode.enable = true;
        steam = {
          enable = true;
          gamescopeSession.enable = true;
          remotePlay.openFirewall = true;
          dedicatedServer.openFirewall = true;
          extraCompatPackages = with pkgs; [
            proton-ge-bin
          ];
        };
      };
      home-manager.users.${username} = {pkgs, ...}: {
        home.packages = with pkgs; [
          #factorio
          #factorio-space-age
          prismlauncher
          (pkgs.heroic.override {
            extraPkgs = pkgs: [
              pkgs.gamemode
              pkgs.gamescope
              pkgs.mangohud
            ];
          })
        ];

        home.sessionVariables = {
          AMD_VULKAN_ICD = "RADV";
          RADV_PERFTEST = "gpl";
          INTEL_VULKAN_ICD = "ANV";
        };

        programs = {
          mangohud = {
            enable = true;
            settings = {
              fps = true;
              frametime = true;
              cpu_stats = true;
              gpu_stats = true;
              ram = true;
              vram = true;
              position = "top-left";
            };
          };

          lutris = {
            enable = true;
            extraPackages = with pkgs; [
              mangohud
              gamemode
              winetricks
              gamescope
              umu-launcher
            ];

            winePackages = with pkgs; [
              wineWow64Packages.staging
              wineWow64Packages.full
            ];

            protonPackages = with pkgs; [
              proton-ge-bin
            ];
          };
        };
      };
    };
  };
}
