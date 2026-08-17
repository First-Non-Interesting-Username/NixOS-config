# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{...}: {
  flake = {
    nixosModules.CHANGEME = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories =
            # Omit this block if you don't plan including any subdirectories of /var/lib
            lib.filter (
              d: let
                dir =
                  if builtins.isString d
                  then d
                  else d.directory;
              in
                !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
            ) [
              # System-level dirs to persist
            ];
          files = [
            # System-level files to persist
          ];
          users.${config.custom.user.name} = {
            directories = [
              # User-level dirs to persist (relative to $HOME)
            ];
            files = [
              # User-level files to persist (relative to $HOME)
            ];
          };
        };
      };

      # System config goes here

      home-manager.users.${config.custom.user.name} = {...}: {
        # Home config goes here
      };
    };
  };
}
