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
      username,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        inputs.hexecute.packages.${pkgs.stdenv.hostPlatform.system}.default
        brightnessctl
      ];
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        ...
      }: {
        imports = [
          self.nixosModules.vicinae
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
          hyprpolkitagent.enable = true;
          cliphist = {
            enable = true;
            allowImages = true;
          };
        };
      };
    };
  };
}
