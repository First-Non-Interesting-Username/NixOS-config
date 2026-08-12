# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{...}: {
  imports = [../common/desktop-modules.nix];

  custom = {
    stylix = {
      image = {
        width = "2560";
        height = "1440";
      };
    };
  };
}
