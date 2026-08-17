# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "browser";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.default = {...}: {
        imports = [
          self.nixosModules.browser
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
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
        default.wait_for_unit("multi-user.target")
        default.wait_for_unit("home-manager-${username}.service")

        default.succeed("su - ${username} -c 'cat ~/.config/mimeapps.list | grep -q \"text/html=firefox.desktop\"'")
        default.succeed("su - ${username} -c 'cat ~/.config/mimeapps.list | grep -q \"x-scheme-handler/https=firefox.desktop\"'")

        default.succeed("su --login ${username} -c 'echo \$BROWSER' | grep -q firefox")
        default.succeed("su --login ${username} -c 'echo \$DEFAULT_BROWSER' | grep -q firefox")
      '';
    };
  };
}
