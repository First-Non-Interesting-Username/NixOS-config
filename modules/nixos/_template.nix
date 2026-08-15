# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{...}: let
  modulename = "CHANGEME";
in {
  flake = {
    nixosModules.${modulename} = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.${modulename};
    in {
      options.custom.${modulename} = {
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
