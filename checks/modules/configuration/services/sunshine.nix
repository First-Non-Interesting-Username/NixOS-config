# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "sunshine";
    username = "testuser";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;

      nodes = {
        machine = {...}: {
          imports = [
            self.nixosModules.user
            self.nixosModules.preservation
            self.nixosModules.home-manager
            self.nixosModules.sunshine
          ];
          custom = {
            user = {
              enable = true;
              name = username;
              password = username;
            };
          };
          services.cage = {
            enable = true;
            user = username;
            program = "${pkgs.ungoogled-chromium}/bin/chromium-browser --kiosk \"http://localhost:47990\"";
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
        uid = toString nodes.machine.users.users.${username}.uid;
      in ''
        machine.wait_for_unit("multi-user.target")

        machine.wait_for_file("/run/user/${uid}/wayland-0.lock")

        machine.wait_until_succeeds("pgrep -x chromium")

        machine.wait_for_text("Sunshine|username|password")

        # Test if 5353 is open and UDP
        machine.wait_until_succeeds("ss -ulpn | grep :5353")
        client.succeed("echo \'\' | socat -t 2 - UDP:machine:5353")

        tcp_ports = [47984, 47989, 47990, 48010]


        for port in tcp_ports:
                machine.wait_for_open_port(port)
                client.wait_until_succeeds(f"nc -z -w 2 machine {port}")

        udp_ports = [47998, 47999, 48000, 48002, 48010]
        for port in udp_ports:
                machine.wait_until_succeeds("ss -ulpn | grep :{port}")
                client.succeed("echo \'\' | socat -t 2 - UDP:machine:{port}")

        services = ["sunshine.service", "avahi-daemon.service"]
        for service in services:
                machine.succeed(f"systemctl is-failed {service} || true")
                machine.wait_for_unit(service)
                machine.succeed(f"systemctl is-active {service}")
      '';
    };
  };
}
