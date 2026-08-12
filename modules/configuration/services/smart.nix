# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  flake = {
    nixosModules.smart = {
      lib,
      config,
      pkgs,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories =
            lib.filter (
              d: let
                dir =
                  if builtins.isString d
                  then d
                  else d.directory;
              in
                !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
            ) [
              "/var/lib/smartmontools"
            ];
        };
      };

      environment.systemPackages = with pkgs; [smartmontools];

      services.smartd = {
        enable = true;
        notifications = {
          systembus-notify.enable = true;
          wall.enable = true;
        };
        defaults.autodetected = "-a -s (S/../.././02)";
      };
    };
  };
}
