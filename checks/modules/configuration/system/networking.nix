# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {pkgs, ...}: let
    checkname = "networking";
    username = "testuser";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;

      nodes.machine = {...}: {
        imports = [
          self.nixosModules.user
          self.nixosModules.preservation
          self.nixosModules.home-manager
          self.nixosModules.secretless-networking-desktop
        ];
        custom = {
          user = {
            enable = true;
            name = username;
            password = username;
          };
        };

        environment.systemPackages = [pkgs.dnsutils];
      };

      testScript = ''
        machine.wait_for_unit("resolvconf.service")
        machine.wait_for_unit("network.target")
        machine.wait_for_unit("NetworkManager.service")

        resolv = machine.succeed("cat /etc/resolv.conf")
        print(resolv)
        assert "nameserver 1.1.1.1" in resolv, resolv
        assert "nameserver 1.0.0.1" in resolv, resolv

        nm = machine.succeed("NetworkManager --print-config")
        print(nm)
        assert "dns=none" in nm, nm

        _status, dig = machine.execute("dig +time=1 +tries=1 example.com")
        print(dig)
        assert "SERVER: 1.1.1.1" in dig, dig
      '';
    };
  };
}
