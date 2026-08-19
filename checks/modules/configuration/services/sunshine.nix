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

          virtualisation.memorySize = 1024;
          environment.systemPackages = with pkgs; [
            curl
            netcat-openbsd
            socat
            iproute2
          ];
        };
        client = {...}: {
          environment.systemPackages = [pkgs.netcat-openbsd pkgs.socat];
        };
      };

      testScript = ''
        machine.wait_for_unit("multi-user.target")
        client.wait_for_unit("multi-user.target")

        machine.wait_for_open_port(47990)
        machine.succeed(
            "curl -kfsS --max-time 10 https://127.0.0.1:47990 | grep -qiE 'sunshine|username|password|login'"
        )

        machine.wait_until_succeeds("ss -ulpn | grep :5353")
        client.wait_until_succeeds("ping -4 -c 1 -W 1 machine")
        client.succeed("echo \'\' | socat -t 2 - UDP4:machine:5353")

        tcp_ports = [47984, 47989, 47990, 48010]
        for port in tcp_ports:
                machine.wait_for_open_port(port)
                client.wait_until_succeeds(f"nc -z -w 2 machine {port}")

        udp_ports = [47998, 47999, 48000, 48002, 48010]
        for port in udp_ports:
                machine.wait_until_succeeds(f"ss -ulpn | grep :{port}")
                client.succeed(f"echo \'\' | socat -t 2 - UDP4:machine:{port}")

        machine.wait_for_unit("sunshine.service", user="${username}")
        rc, _ = machine.systemctl("is-active sunshine", "${username}")
        assert rc == 0, "user service sunshine is not active"

        machine.wait_for_unit("avahi-daemon.service")
        machine.succeed("systemctl is-active avahi-daemon")
      '';
    };
  };
}
