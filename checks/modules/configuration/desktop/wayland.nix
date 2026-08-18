# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "wayland";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          self.nixosModules.wayland
        ];
        custom = {
          user = {
            enable = true;
            name = username;
            password = username;
          };
        };
      };

      testScript = ''
        machine.succeed("which wl-copy")
        machine.succeed("which wl-paste")

        machine.wait_for_unit("dbus.service")
        machine.wait_for_unit("polkit.service")
      '';
    };
  };
}
