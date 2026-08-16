# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  perSystem = {pkgs, ...}: {
    packages.rebuild = pkgs.writeShellApplication {
      name = "rebuild";
      runtimeInputs = with pkgs; [
        nh
      ];
      text = ''
        nh os boot github:First-Non-Interesting-Username/NixOS-config/main#"$HOSTNAME"
      '';
    };
  };
}
