{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.networking-desktop = {
      pkgs,
      lib,
      config,
      hostname,
      ...
    }: {
      networking = {
        hostName = hostname;
        networkmanager.enable = true;

        useDHCP = lib.mkDefault true;

        firewall = {
          enable = true;
          # allowedTCPPorts = [ ... ];
          # allowedUDPPorts = [ ... ];
        };
      };

      hardware.bluetooth = {
        enable = true;
        powerOnBoot = true;
      };
    };
    nixosModules.networking-server = {
      pkgs,
      lib,
      config,
      hostname,
      ...
    }: {
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
    nixosModules.networking-minimal = {
      pkgs,
      lib,
      config,
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
}
