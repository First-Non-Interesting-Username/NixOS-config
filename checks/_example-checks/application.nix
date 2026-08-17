# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "CHANGEME";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          # Usually needed
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
          program = "YOUR PROGRAM EXECUTABLE";
        };

        # Upstream does that, not gonna question
        virtualisation.qemu.options = ["-vga none -device virtio-gpu-pci"];
        fonts.packages = with pkgs; [dejavu_fonts];
      };

      enableOCR = true;

      testScript = {nodes, ...}: let
        uid = toString nodes.machine.config.users.users.${username}.uid;
      in ''

        machine.wait_for_unit("multi-user.target")
        # Usually you want to wait for home manager
        machine.wait_for_unit("home-manager-${username}.service")

        machine.succeed("su - ${username} -c 'command -v YOUR PROGRAM EXECUTABLE'")

        machine.wait_for_file("/run/user/${uid}/wayland-0.lock")

        machine.wait_until_succeeds("pgrep -x YOUR PROGRAM EXECUTABLE")

        machine.wait_for_text("TEXT YOUR PROGRAM MIGHT DISPLAY")
      '';
    };
  };
}
