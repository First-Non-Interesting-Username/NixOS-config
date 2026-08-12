# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  perSystem = {inputs', ...}: {
    packages.hexecute-gnome = inputs'.hexecute-gnome.packages.default;
  };
}
