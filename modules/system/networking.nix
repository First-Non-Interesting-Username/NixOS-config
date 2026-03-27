_: {
  flake = {
    nixosModules = {
      networking-desktop = {
        lib,
        hostname,
        impermanence,
        ...
      }: {
        networking = {
          hostName = hostname;
          networkmanager.enable = true;

          useDHCP = lib.mkDefault true;

          firewall = {
            enable = true;
          };
        };

        hardware.bluetooth = {
          enable = true;
          powerOnBoot = true;
        };

        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/etc/NetworkManager"
              "/var/lib/NetworkManager"
              "/var/lib/bluetooth"
            ];
          };
        };
      };
      networking-server = {hostname, ...}: {
        networking = {
          hostName = hostname;
          networkmanager.enable = false;

          interfaces.ens18 = {
            useDHCP = false;
            ipv4.addresses = [
              {
                address = "192.168.0.124";
                prefixLength = 24;
              }
            ];
          };

          defaultGateway = "192.168.0.1";
          nameservers = ["192.168.0.1"];

          firewall = {
            enable = true;
            allowedTCPPorts = [
              22
              80
              443
            ];
          };
        };
      };
      networking-minimal = {
        lib,
        hostname,
        ...
      }: {
        networking = {
          hostName = hostname;
          networkmanager.enable = true;

          useDHCP = lib.mkDefault true;

          firewall = {
            enable = true;
          };
        };
      };
    };
  };
}
