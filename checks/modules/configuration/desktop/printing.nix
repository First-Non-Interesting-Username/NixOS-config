# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "printing";
    username = "test";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes = {
        machine = {...}: {
          imports = [
            self.nixosModules.user
            self.nixosModules.preservation
            self.nixosModules.home-manager
            self.nixosModules.printing
          ];
          custom = {
            user = {
              enable = true;
              name = username;
              password = username;
            };
            stylix.enable = false;
          };
          services.cage = {
            enable = true;
            user = username;
            program = "${pkgs.ungoogled-chromium}/bin/chromium-browser --kiosk \"http://localhost:631\"";
          };

          # Upstream does that, not gonna question
          virtualisation.qemu.options = ["-vga none -device virtio-gpu-pci"];
          virtualisation.memorySize = 2048;
          fonts.packages = with pkgs; [dejavu_fonts];
          environment.systemPackages = [pkgs.netcat-openbsd pkgs.socat];
        };
        client = {...}: {
          environment.systemPackages = [pkgs.netcat-openbsd pkgs.socat];
        };
      };

      enableOCR = true;

      testScript = {nodes, ...}: let
        uid = toString nodes.machine.config.users.users.${username}.uid;
      in ''
        machine.wait_for_unit("multi-user.target")

        machine.wait_for_file("/run/user/${uid}/wayland-0.lock")

        machine.wait_until_succeeds("pgrep -x chromium")

        machine.wait_for_text("CUPS")

        # Test if 5353 is open and service UDP
        machine.wait_until_succeeds("ss -ulpn | grep :5353")
        client.succeed("echo \'\' | socat -t 2 - UDP:machine:5353")

        # Test if 631 is closed
        machine.wait_for_open_port(631)
        machine.succeed("nc -zv 127.0.0.1 631")
        client.fail("nc -zv -w 2 machine 631")

        services = ["cups.service", "cups-browsed.service", "avahi-daemon.service"]
        for service in services:
                machine.succeed(f"systemctl is-failed {service} || true")
                machine.wait_for_unit(service)
                machine.succeed(f"systemctl is-active {service}")
      '';
    };
  };
}
