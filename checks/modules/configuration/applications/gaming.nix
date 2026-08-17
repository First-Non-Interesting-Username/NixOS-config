# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "gaming";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.default = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          self.nixosModules.gaming
        ];
        custom = {
          user = {
            enable = true;
            name = username;
            password = username;
          };
          stylix.enable = true;
        };
      };

      testScript = ''
        # Python test script
        # https://nixos.org/manual/nixos/unstable/#ssec-machine-objects - docs
      '';
    };
  };
}
