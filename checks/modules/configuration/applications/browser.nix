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

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.browser
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          self.nixosModules.stylix
        ];
        custom = {
          user = {
            enable = true;
            name = username;
            password = username;
          };
          stylix.enable = true;
        };
        services.cage = {
          enable = true;
          user = username;
          program = "${pkgs.firefox}/bin/firefox";
          environment = {MOZ_ENABLE_WAYLAND = "1";};
        };

        virtualisation.qemu.options = ["-vga none -device virtio-gpu-pci"];
        virtualisation.memorySize = 2048;
        fonts.packages = with pkgs; [dejavu_fonts];
      };

      enableOCR = true;

      testScript = {nodes, ...}: let
        uid = toString nodes.machine.config.users.users.${username}.uid;
      in ''

        machine.wait_for_unit("multi-user.target")
        machine.wait_for_unit("home-manager-${username}.service")

        machine.succeed("su - ${username} -c 'command -v firefox'")

        machine.succeed("su - ${username} -c 'cat ~/.config/mimeapps.list | grep -q \"text/html=firefox.desktop\"'")
        machine.succeed("su - ${username} -c 'cat ~/.config/mimeapps.list | grep -q \"x-scheme-handler/https=firefox.desktop\"'")

        machine.succeed("su - ${username} -c 'echo $BROWSER' | grep -q firefox")
        machine.succeed("su - ${username} -c 'echo $DEFAULT_BROWSER' | grep -q firefox"

        machine.wait_for_file("/run/user/${uid}/wayland-0.lock")

        machine.wait_until_succeeds("pgrep -x firefox")

        machine.wait_for_text("Firefox|Google|Mozilla|Welcome")
      '';
    };
  };
}
