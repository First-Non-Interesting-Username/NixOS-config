# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  flake = {
    nixosModules.hostname = {
      lib,
      config,
      ...
    }: let
      cfg = config.custom.hostname;
    in {
      options.custom = {
        hostname = lib.mkOption {
          type = lib.types.str or null;
          default = null;
          example = "some_hostname";
          description = "hostname for your system";
        };
      };

      config = {
        networking.hostName = cfg;
      };
    };
  };
}
