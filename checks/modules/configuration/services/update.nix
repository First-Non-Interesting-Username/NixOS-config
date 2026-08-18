# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "update";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          self.nixosModules.hostname
          self.nixosModules.update
        ];
        custom = {
          hostname = username;
          user = {
            enable = true;
            name = username;
            password = username;
          };
        };
        virtualisation.writableStore = true;
        virtualisation.memorySize = 2048;
      };

      testScript = ''
        machine.wait_for_unit("default.target")

        machine.succeed("systemctl start nh-clean.service")
        machine.succeed("systemctl start nix-optimise.service")

        services = ["nh-clean.service", "nixos-upgrade.service", "nix-optimise.service"]

        for services in services:
              machine.succeed(f"systemctl cat {unit}")

        machine.wait_for_unit("nix-daemon.socket")
        machine.succeed("systemctl start nix-optimise.service", timeout=600)
        machine.succeed("systemctl start nh-clean.service", timeout=300)
      '';
    };
  };
}
