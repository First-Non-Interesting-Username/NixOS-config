# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  perSystem = {pkgs, ...}: let
    checkname = "CHANGEME";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.default = _: {
        # VM config goes here
      };

      testScript = ''
        # Python test script
        # https://nixos.org/manual/nixos/unstable/#ssec-machine-objects - docs
      '';
    };
  };
}
