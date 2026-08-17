# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "gnome-minimal";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.default = {
        lib,
        pkgs,
        ...
      }: {
        imports = [
          self.nixosModules.DE
          self.nixosModules.user
          self.nixosModules.stylix
          self.nixosModules.preservation
        ];
        custom = {
          user = {
            enable = true;
            name = "test";
            password = "test";
          };
          stylix = {
            enable = true;
            image = {
              width = lib.mkDefault "2560";
              height = lib.mkDefault "1440";
              enable = true;
            };
            base16Scheme = "gruvbox-dark";
            icons = {
              package = pkgs.morewaita-icon-theme;
              name = "MoreWaita";
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
        machine.wait_for_unit("gdm.service")
      '';
    };
  };
}
