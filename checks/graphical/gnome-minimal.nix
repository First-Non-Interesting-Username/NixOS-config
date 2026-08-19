# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "gnome-minimal";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;

      nodes.machine = {
        lib,
        pkgs,
        ...
      }: {
        _module.args.inputs = self.inputs;

        imports = [
          self.nixosModules.DE
          self.nixosModules.user
          self.nixosModules.stylix
          self.nixosModules.preservation
          self.nixosModules.home-manager
        ];
        custom = {
          user = {
            enable = true;
            name = "testuser";
            password = "testuser";
          };
          stylix = {
            enable = true;
            image = {
              enable = true;
            };
          };
          preservation.enable = false;
          DE = {
            enable = true;
            name = "gnome";
          };
        };
      };

      testScript = ''
        machine.wait_for_unit("graphical.target")
        machine.wait_for_unit("display-manager.service")
      '';
    };
  };
}
