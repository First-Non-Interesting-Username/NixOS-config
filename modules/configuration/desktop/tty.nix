# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  flake = {
    nixosModules.tty = _: {
      services = {
        kmscon = {
          enable = true;
          config.hwaccel = true;
        };
        gpm = {
          enable = true;
          protocol = "imps2";
        };
      };
    };
  };
}
