# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{inputs, ...}: {
  flake = {
    nixosModules.flatpak = {
      pkgs,
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories = [
            "/var/lib/flatpak"
          ];
          users.${config.custom.user.name} = {
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
      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
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
            # Useless on a declarative system
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
