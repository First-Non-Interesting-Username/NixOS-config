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

          systemd.user.services.sunshine.wantedBy = ["default.target"];

          services.cage = {
            enable = true;
            user = username;
            program = pkgs.writeShellScript "sunshine-webui-kiosk" ''
              for _ in $(${pkgs.coreutils}/bin/seq 1 120); do
                ${pkgs.netcat-openbsd}/bin/nc -z localhost 47990 && break
                ${pkgs.coreutils}/bin/sleep 1
              done
              exec ${pkgs.ungoogled-chromium}/bin/chromium-browser \
                --kiosk \
                --no-first-run \
                --no-default-browser-check \
                --ignore-certificate-errors \
                "https://localhost:47990"
            '';
            environment = {
              WLR_RENDERER = "pixman";
            };
          };

          # Upstream does that, not gonna question
          virtualisation.qemu.options = ["-vga none -device virtio-gpu-pci"];
          virtualisation.memorySize = 3072;
          fonts.packages = with pkgs; [dejavu_fonts];

          environment.systemPackages = with pkgs; [
            netcat-openbsd
            socat
            iproute2
          ];
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

        machine.wait_for_open_port(47990)

        machine.wait_until_succeeds("pgrep -x chromium")

        machine.wait_for_text("(?i)sunshine|username|password")

        machine.wait_until_succeeds("ss -ulpn | grep :5353")
        # Ensure the client's IPv4 path to the machine is up before the
        # forced-IPv4 probe (eth1's IPv4 address races with its IPv6 one).
        client.wait_until_succeeds("ping -4 -c 1 -W 1 machine")
        client.succeed("echo \'\' | socat -t 2 - UDP4:machine:5353")

        tcp_ports = [47984, 47989, 47990, 48010]
        for port in tcp_ports:
                machine.wait_for_open_port(port)
                client.wait_until_succeeds(f"nc -z -w 2 machine {port}")

        udp_ports = [47998, 47999, 48000, 48002, 48010]
        for port in udp_ports:
                machine.wait_until_succeeds("ss -ulpn | grep :{port}")
                client.succeed("echo \'\' | socat -t 2 - UDP4:machine:{port}")

        machine.wait_for_unit("sunshine.service", user="${username}")
        rc, _ = machine.systemctl("is-active sunshine", "${username}")
        assert rc == 0, "user service sunshine is not active"

        machine.wait_for_unit("avahi-daemon.service")
        machine.succeed("systemctl is-active avahi-daemon")
      '';
    };
  };
}
