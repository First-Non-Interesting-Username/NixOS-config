# SPDX-FileCopyrightText: 2026 first-uninteresting-username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{inputs, ...}: {
  flake = {
    nixosModules.slick = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/slick"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        xdg.mimeApps.defaultApplications = {
          "x-scheme-handler/slack" = "dev.slick.Slick.desktop";
        };

        home.packages = [
          (inputs.slick.packages.${pkgs.stdenv.hostPlatform.system}.slick.override {
            slackPackage = pkgs.slack;
          })
        ];
      };
    };
  };
}
