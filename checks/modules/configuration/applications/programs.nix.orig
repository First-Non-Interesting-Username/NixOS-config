# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
<<<<<<<< HEAD:checks/modules/configuration/applications/sudo.nix
    checkname = "sudo";
    username = "testuser";
========
    checkname = "programs";
    username = "test";
>>>>>>>> 29b3dbd (tests: do not test the gaming module):checks/modules/configuration/applications/programs.nix
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
<<<<<<<< HEAD:checks/modules/configuration/applications/sudo.nix
          self.nixosModules.sudo
========
          self.nixosModules.programs
>>>>>>>> 29b3dbd (tests: do not test the gaming module):checks/modules/configuration/applications/programs.nix
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
        machine.succeed("sudo --version | grep -i sudo-rs")
      '';
    };
  };
}
