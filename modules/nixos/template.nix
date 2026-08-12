# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{...}: {
  flake = {
    nixosModules.CHANGEME = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.CHANGEME;
    in {
      options.custom.CHANGEME = {
        # Create options here
        # Each option should have:
        # - type
        # - default
        # - example
        # - description
      };

      config = {
        # Add config here
      };
    };
  };
}
