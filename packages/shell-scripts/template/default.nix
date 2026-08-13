# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  perSystem = {pkgs, ...}: {
    packages.shell-scripts-CHANGEME = pkgs.writeShellApplication {
      name = "CHANGEME";
      runtimeInputs = with pkgs; [
      ];
      text = ''
        # here is the place for the script
      '';
    };
  };
}
