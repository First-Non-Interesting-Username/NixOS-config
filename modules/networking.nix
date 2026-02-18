{
  self,
  inputs,
  hostname,
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
      ...
    }: {
      # TBD
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
