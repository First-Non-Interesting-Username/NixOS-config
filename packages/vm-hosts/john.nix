# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {...}: {
    apps.john.program = "${self.nixosConfigurations.john.config.system.build.vm}/bin/run-john-vm";
  };
}
