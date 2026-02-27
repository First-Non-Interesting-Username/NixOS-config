{
  self,
  inputs,
  hostname,
  domain,
  ...
}:
{
  flake = {
    nixosModules.nps =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;
        networking.firewall = {
          allowedTCPPorts = [ 6881 ];
          allowedUDPPorts = [ 6881 ];
        };
      };
    homeModules.nps =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        imports = [ inputs.nix-podman-stacks.homeManagerModules.default ];
        nps = {
          defaultTz = "Europe/Warsaw";
          externalStorageBaseDir = "/mnt/storage";
          hostIP4Address = "192.168.0.200";
          storageBaseDir = "/mnt/data";
          stacks = {

            lldap = {
              enable = true;
              baseDn = "DC=iameasytoremember,DC=duckdns,DC=org";
              jwtSecretFile = config.sops.secrets."lldap/jwt_secret".path;
              keySeedFile = config.sops.secrets."lldap/key_seed".path;
              adminPasswordFile = config.sops.secrets."lldap/admin_password".path;
            };

            authelia = {
              enable = true;
              jwtSecretFile = config.sops.secrets."authelia/jwt_secret".path;
              sessionSecretFile = config.sops.secrets."authelia/session_secret".path;
              storageEncryptionKeyFile = config.sops.secrets."authelia/encryption_key".path;
              sessionProvider = "redis";
              oidc = {
                enable = true;
                hmacSecretFile = config.sops.secrets."authelia/oidc_hmac_secret".path;
                jwksRsaKeyFile = config.sops.secrets."authelia/oidc_rsa_pk".path;
              };
            };

            blocky = {
              enable = true;
              enableGrafanaDashboard = true;
              enablePrometheusExport = true;

              settings = {
                upstreams.groups.default = [
                  "https://one.one.one.one/dns-query"
                  "https://dns.quad9.net/dns-query"
                ];
                blocking = {
                  denylists.ads = [
                    "https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts"
                  ];
                  clientGroupsBlock.default = [ "ads" ];
                };
                ports = {
                  dns = 53;
                  http = 4000;
                };
              };
            };

            crowdsec = {
              enable = true;
              enableGrafanaDashboard = true;
              enablePrometheusExport = true;

              extraEnv = {
                ENROLL_INSTANCE_NAME = "${hostname}";
                ENROLL_KEY.fromFile = config.sops.secrets."crowdsec/enroll_key".path;
              };
            };

            ddns-updater = {
              enable = true;
              settings = [
                {
                  provider = "duckdns";
                  domain = "${domain}";
                  token = "{{ file.Read `${config.sops.secrets."DUCKDNS_TOKEN".path}`}}";
                  ip_version = "ipv4";
                }
              ];
            };

            docker-socket-proxy.enable = true;

            dozzle.enable = true;

            filebrowser-quantum = {
              enable = true;
              mounts = {
                ${config.home.homeDirectory} = {
                  path = config.home.homeDirectory;
                  name = config.home.username;
                };
                ${config.nps.externalStorageBaseDir} = {
                  path = "/hdd";
                  name = "hdd";
                };
              };
              oidc = {
                enable = true;
                clientSecretFile = config.sops.secrets."filebrowser-quantum/authelia/client_secret".path;
              };
              settings.auth.methods.password.enabled = false;
            };

            flaresolverr.enable = true;

            homepage = {
              enable = true;
            };

            microbin = {
              enable = true;

              extraEnv = {
                MICROBIN_ADMIN_USERNAME = "admin";
                MICROBIN_ADMIN_PASSWORD.fromFile = config.sops.secrets."microbin/admin_password".path;
              };
            };

            monitoring = {
              enable = true;

              grafana = {
                oidc = {
                  enable = true;
                  clientSecretFile = config.sops.secrets."grafana/authelia/client_secret".path;
                };
              };
            };

            n8n.enable = true;

            navidrome.enable = true;

            searxng = {
              enable = true;
              secretKeyFile = config.sops.secrets."searxng/secret_key".path;
            };

            streaming = {
              enable = true;
              gluetun.enable = false;
              seerr.enable = true;
              profilarr.enable = true;

              jellyfin = {
                oidc = {
                  enable = true;
                  clientSecretFile = config.sops.secrets."jellyfin/authelia/client_secret".path;
                };
              };

              qui = {
                enable = true;
                oidc = {
                  enable = true;
                  clientSecretFile = config.sops.secrets."qui/authelia/client_secret".path;
                };
              };
              qbittorrent.extraEnv = {
                TORRENTING_PORT = "6881";
              };

            };
            traefik = {
              enable = true;

              domain = "${domain}";

              extraEnv = {
                DUCKDNS_TOKEN.fromFile = config.sops.secrets."DUCKDNS_TOKEN".path;
              };

              staticConfig.certificatesResolvers.letsencrypt.acme.dnsChallenge.provider = "duckdns";

              geoblock = {
                enable = true;
                allowedCountries = [
                  "AT"
                  "BE"
                  "BG"
                  "HR"
                  "CY"
                  "CZ"
                  "DK"
                  "EE"
                  "FI"
                  "FR"
                  "DE"
                  "GR"
                  "HU"
                  "IE"
                  "IT"
                  "LV"
                  "LT"
                  "LU"
                  "MT"
                  "NL"
                  "PL"
                  "PT"
                  "RO"
                  "SK"
                  "SI"
                  "ES"
                  "SE"
                ];
              };

              crowdsec = {
                enableLogCollection = true;
                middleware = {
                  enable = true;
                  bouncerKeyFile = config.sops.secrets."traefik/crowdsec_bouncer_key".path;
                };
              };

              enablePrometheusExport = true;
              enableGrafanaMetricsDashboard = true;
              enableGrafanaAccessLogDashboard = true;
            };
          };

          sops.secrets = {
            "authelia/jwt_secret" = { };
            "authelia/session_secret" = { };
            "authelia/encryption_key" = { };
            "authelia/oidc_hmac_secret" = { };
            "authelia/oidc_rsa_pk" = { };
            "lldap/jwt_secret" = { };
            "lldap/key_seed" = { };
            "lldap/admin_password" = { };
            "crowdsec/enroll_key" = { };
            "crowdsec/traefik_bouncer_key" = { };
            "DUCKDNS_TOKEN" = { };
            "filebrowser-quantum/authelia/client_secret" = { };
            "microbin/admin_password" = { };
            "grafana/authelia/client_secret" = { };
            "searxng/secret_key" = { };
            "jellyfin/authelia/client_secret" = { };
            "qui/authelia/client_secret" = { };
            "traefik/crowdsec_bouncer_key" = { };
          };
        };
      };
  };
}
