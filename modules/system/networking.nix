_: {
  flake = {
    nixosModules.networking-desktop =
      {
        lib,
        hostname,
        impermanence,
        config,
        ...
      }:
      {
        sops.secrets."wifi_password" = { };
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

        systemd.services.nm-wifi-secret = {
          description = "Write WiFi secret to NetworkManager keyfile";
          wantedBy = [ "multi-user.target" ];
          after = [ "sops-nix.service" ];
          serviceConfig.Type = "oneshot";
          script = ''
              mkdir -p /etc/NetworkManager/system-connections

              WIFI_PSK=$(cat ${config.sops.secrets."wifi_password".path})
              WIFI_PSK_2=$(cat ${config.sops.secrets."wifi_password_2".path})

              cat > /etc/NetworkManager/system-connections/malti.nmconnection << EOF
            [connection]
            id=MALTI
            type=wifi

            [wifi]
            ssid=MALTI
            mode=infrastructure

            [wifi-security]
            auth-alg=open
            key-mgmt=wpa-psk
            psk=$WIFI_PSK

            [ipv4]
            method=auto

            [ipv6]
            method=auto
            EOF

              cat > /etc/NetworkManager/system-connections/secondnet.nmconnection << EOF
            [connection]
            id=SECONDNET
            type=wifi

            [wifi]
            ssid=SECONDNET
            mode=infrastructure

            [wifi-security]
            auth-alg=open
            key-mgmt=wpa-psk
            psk=$WIFI_PSK_2

            [ipv4]
            method=auto

            [ipv6]
            method=auto
            EOF

              chmod 600 /etc/NetworkManager/system-connections/malti.nmconnection
              chmod 600 /etc/NetworkManager/system-connections/secondnet.nmconnection
              systemctl reload NetworkManager || true
          '';
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
    nixosModules.secretless-networking-desktop =
      {
        lib,
        hostname,
        impermanence,
        ...
      }:
      {
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
    nixosModules.networking-server =
      { hostname, ... }:
      {
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
          nameservers = [ "192.168.0.1" ];

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
    nixosModules.networking-minimal =
      {
        lib,
        hostname,
        ...
      }:
      {
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
