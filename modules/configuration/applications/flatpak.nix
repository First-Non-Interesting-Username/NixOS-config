{inputs, ...}: {
  flake = {
    nixosModules.flatpak = {
      pkgs,
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [
            "/var/lib/flatpak"
          ];
          users.${username} = {
            directories = [
              ".local/share/flatpak"
              ".var/app"
            ];
          };
        };
      };

      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = "*";
      };
      home-manager.users.${username} = {pkgs, ...}: {
        imports = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];

        services.flatpak = {
          update.onActivation = true;
          remotes = [
            {
              name = "flathub";
              location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            }
          ];
          packages = [
            "com.github.tchx84.Flatseal"
          ];
          uninstallUnmanaged = true;
        };

        home.packages = with pkgs; [
          warehouse
        ];
      };
    };
  };
}
