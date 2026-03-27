{inputs, ...}: {
  flake = {
    nixosModules.nps = {username, ...}: {
      boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 53;
      networking.firewall = {
        allowedTCPPorts = [
          6881
          51820
        ];
        allowedUDPPorts = [
          6881
          51820
        ];
      };

      systemd.tmpfiles.rules = [
        "d /mnt/data/traefik/letsencrypt 0755 ${username} users -"
        "f /mnt/data/traefik/letsencrypt/acme.json 0600 ${username} users -"
      ];

      sops.secrets = {
        "authelia/jwt_secret".owner = username;
        "authelia/session_secret".owner = username;
        "authelia/encryption_key".owner = username;
        "authelia/oidc_hmac_secret".owner = username;
        "authelia/oidc_rsa_pk".owner = username;
        "lldap/jwt_secret".owner = username;
        "lldap/key_seed".owner = username;
        "lldap/admin_password".owner = username;
        "crowdsec/enroll_key".owner = username;
        "crowdsec/traefik_bouncer_key".owner = username;
        "DUCKDNS_TOKEN".owner = username;
        "filebrowser_quantum/authelia/client_secret".owner = username;
        "microbin/admin_password".owner = username;
        "grafana/authelia/client_secret".owner = username;
        "searxng/secret_key".owner = username;
        "jellyfin/authelia/client_secret".owner = username;
        "qui/authelia/client_secret".owner = username;
        "traefik/crowdsec_bouncer_key".owner = username;
        "wg_easy/admin_password".owner = username;
        "lldap/user_password".owner = username;
      };
      home-manager.users.${username} = {
        lib,
        config,
        osConfig,
        hostname,
        domain,
        gitEmail,
        ...
      }: {
        imports = [inputs.nix-podman-stacks.homeModules.nps];
        nps = {
          defaultTz = "Europe/Warsaw";
          externalStorageBaseDir = "/mnt/storage";
          hostIP4Address = "192.168.0.124";
          storageBaseDir = "/mnt/data";
          stacks = {
            lldap = {
              enable = true;
              baseDn = "DC=iameasytoremember,DC=duckdns,DC=org";
              jwtSecretFile = osConfig.sops.secrets."lldap/jwt_secret".path;
              keySeedFile = osConfig.sops.secrets."lldap/key_seed".path;
              adminPasswordFile = osConfig.sops.secrets."lldap/admin_password".path;

              bootstrap.users.admin = {
                id = "admin";
                email = gitEmail;
                password_file = osConfig.sops.secrets."lldap/user_password".path;
                displayName = "Admin";
                groups = [
                  "lldap_admin"
                  "lldap_password_manager"
                  "filebrowser-quantum_admin"
                  "filebrowser-quantum_user"
                  "grafana_admin"
                  "jellyfin_admin"
                  "jellyfin_user"
                  "qui_user"
                ];
              };
            };

            authelia = {
              enable = true;
              jwtSecretFile = osConfig.sops.secrets."authelia/jwt_secret".path;
              sessionSecretFile = osConfig.sops.secrets."authelia/session_secret".path;
              storageEncryptionKeyFile = osConfig.sops.secrets."authelia/encryption_key".path;
              sessionProvider = "redis";
              oidc = {
                enable = true;
                hmacSecretFile = osConfig.sops.secrets."authelia/oidc_hmac_secret".path;
                jwksRsaKeyFile = osConfig.sops.secrets."authelia/oidc_rsa_pk".path;
              };
              settings = {
                notifier.filesystem.filename = lib.mkForce "/config/notification.txt";
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
                  clientGroupsBlock.default = ["ads"];
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
                ENROLL_KEY.fromFile = osConfig.sops.secrets."crowdsec/enroll_key".path;
              };
            };

            ddns-updater = {
              enable = true;
              settings = [
                {
                  provider = "duckdns";
                  domain = "${domain}";
                  token = "{{ file.Read `${osConfig.sops.secrets."DUCKDNS_TOKEN".path}`}}";
                  ip_version = "ipv4";
                }
              ];
            };

            docker-socket-proxy.enable = true;

            dozzle = {
              enable = true;
              containers.dozzle = {
                forwardAuth = {
                  enable = true;
                  rules = [{policy = "two_factor";}];
                };
                expose = true;
              };
            };

            filebrowser-quantum = {
              enable = true;
              mounts = {
                ${config.home.homeDirectory} = {
                  path = "/srv/home";
                  name = config.home.username;
                  config.defaultEnabled = true;
                };
                ${config.nps.externalStorageBaseDir} = {
                  path = "/srv/hdd";
                  name = "hdd";
                  config.defaultEnabled = true;
                };
              };
              oidc = {
                enable = true;
                clientSecretFile = osConfig.sops.secrets."filebrowser_quantum/authelia/client_secret".path;
              };
              settings.auth.methods.password.enabled = false;
              containers.filebrowser-quantum = {
                expose = true;
              };
            };

            flaresolverr.enable = true;

            homepage = {
              enable = true;
              containers.homepage = {
                traefik.subDomain = "homepage";
                forwardAuth = {
                  enable = true;
                  rules = [{policy = "two_factor";}];
                };
                expose = true;
              };
            };

            microbin = {
              enable = true;

              extraEnv = {
                MICROBIN_ADMIN_USERNAME = "admin";
                MICROBIN_ADMIN_PASSWORD.fromFile = osConfig.sops.secrets."microbin/admin_password".path;
              };
              containers.microbin = {
                expose = true;
              };
            };

            monitoring = {
              enable = true;

              grafana = {
                oidc = {
                  enable = true;
                  clientSecretFile = osConfig.sops.secrets."grafana/authelia/client_secret".path;
                };
              };
              containers = {
                alloy = {
                  forwardAuth = {
                    enable = true;
                    rules = [{policy = "two_factor";}];
                  };
                };
                loki = {
                  forwardAuth = {
                    enable = true;
                    rules = [{policy = "two_factor";}];
                  };
                };
                prometheus = {
                  forwardAuth = {
                    enable = true;
                    rules = [{policy = "two_factor";}];
                  };
                };
              };
            };

            n8n = {
              enable = true;
              containers.n8n = {
                expose = true;
              };
            };

            navidrome = {
              enable = true;
              containers.navidrome = {
                expose = true;
              };
            };

            searxng = {
              enable = true;
              secretKeyFile = osConfig.sops.secrets."searxng/secret_key".path;
              containers.searxng = {
                forwardAuth = {
                  enable = true;
                  rules = [{policy = "two_factor";}];
                };
                expose = true;
              };
            };

            streaming = {
              enable = true;
              gluetun.enable = false;
              seerr.enable = true;
              profilarr.enable = true;

              jellyfin = {
                oidc = {
                  enable = true;
                  clientSecretFile = osConfig.sops.secrets."jellyfin/authelia/client_secret".path;
                };
              };

              qui = {
                enable = true;
                oidc = {
                  enable = true;
                  clientSecretFile = osConfig.sops.secrets."qui/authelia/client_secret".path;
                };
              };
              qbittorrent.extraEnv = {
                TORRENTING_PORT = "6881";
              };

              containers = {
                jellyfin = {
                  extraPodmanArgs = ["--tmpfs=/config/cache/transcodes:size=4G"];
                  expose = true;
                };
                qui = {
                  expose = true;
                };
              };
            };

            traefik = {
              enable = true;

              domain = "${domain}";

              extraEnv = {
                DUCKDNS_TOKEN.fromFile = osConfig.sops.secrets."DUCKDNS_TOKEN".path;
              };

              staticConfig.certificatesResolvers.letsencrypt.acme = {
                dnsChallenge = {
                  provider = "duckdns";
                  resolvers = [
                    "1.1.1.1:53"
                    "9.9.9.9:53"
                  ];
                  disablePropagationCheck = true;
                };
                storage = lib.mkForce "/letsencrypt/acme.json";
                email = lib.mkForce gitEmail;
              };

              geoblock = {
                enable = true;
                allowedCountries = [
                  "PL"
                  "CH"
                ];
              };

              crowdsec = {
                enableLogCollection = true;
                middleware = {
                  enable = true;
                  bouncerKeyFile = osConfig.sops.secrets."traefik/crowdsec_bouncer_key".path;
                };
              };

              enablePrometheusExport = true;
              enableGrafanaMetricsDashboard = true;
              enableGrafanaAccessLogDashboard = true;
            };

            wg-easy = {
              enable = true;

              host = "vpn.iameasytoremember.duckdns.org";
              port = 51820;

              adminUsername = "admin";
              adminPasswordFile = osConfig.sops.secrets."wg_easy/admin_password".path;

              extraEnv = {
                DISABLE_IPV6 = true;
                INIT_DNS = "192.168.0.1";
                INIT_ALLOWED_IPS = "192.168.0.0/24, 10.8.0.0/24";
              };
              containers.wg-easy = {
                forwardAuth = {
                  enable = true;
                  rules = [{policy = "two_factor";}];
                };
                expose = true;
              };
            };
          };
        };
      };
    };
  };
}
