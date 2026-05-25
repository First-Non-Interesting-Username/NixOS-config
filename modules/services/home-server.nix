{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.home-server-iroh = {
      lib,
      username,
      impermanence,
      config,
      pkgs,
      ...
    }: let
      domain = "iameasytoremember.duckdns.org";
      email = "janekmusin@proton.me";
      filebrowserStateDir = "/var/lib/filebrowser";
    in {
      imports =
        [
          self.nixosModules.web-expose
          inputs.nixflix.nixosModules.default
          self.nixosModules.ai-services
          inputs.headplane.nixosModules.headplane
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = ["/var/lib"];
          };
        };

      nixpkgs.overlays = [inputs.headplane.overlays.default];

      sops.secrets = {
        "nixflix/sonarr/api-key" = {
          owner = "sonarr";
        };
        "nixflix/sonarr/password" = {
          owner = "sonarr";
        };

        "nixflix/radarr/api-key" = {
          owner = "radarr";
        };
        "nixflix/radarr/password" = {
          owner = "radarr";
        };

        "nixflix/prowlarr/api-key" = {
          owner = "prowlarr";
        };
        "nixflix/prowlarr/password" = {
          owner = "prowlarr";
        };

        "nixflix/seerr/api-key" = {
          owner = "seerr";
        };
        "nixflix/seerr/jellyfin-admin-password" = {
          owner = "seerr";
        };

        "nixflix/jellyfin/users/admin-password" = {
          owner = "jellyfin";
        };
        "nixflix/jellyfin/users/user1-password" = {
          owner = "jellyfin";
        };
        "nixflix/jellyfin/users/user2-password" = {
          owner = "jellyfin";
        };
        "nixflix/jellyfin/api-key" = {
          owner = "jellyfin";
        };

        "nixflix/qbittorrent/password" = {
          owner = "qbittorrent";
        };

        "nixflix/opensubtitles-com/password" = {
          owner = "jellyfin";
        };

        "nixflix/opensubtitles-com/api-key" = {
          owner = "jellyfin";
        };

        "nixflix/subdl/api-key" = {
          owner = "jellyfin";
        };

        "nixflix/subsource/api-key" = {
          owner = "jellyfin";
        };

        "routing/traefik/env" = {
          owner = "traefik";
        };
        "routing/traefik/oidc-session" = {
          owner = "traefik";
        };

        "routing/lldap/admin-password" = {
          owner = "lldap";
        };
        "routing/lldap/jwt-secret" = {
          owner = "lldap";
        };
        "routing/lldap/key-seed" = {
          owner = "lldap";
        };

        "routing/authelia/jwt-secret" = {
          owner = "authelia-main";
        };
        "routing/authelia/session-secret" = {
          owner = "authelia-main";
        };
        "routing/authelia/storage-key" = {
          owner = "authelia-main";
        };
        "routing/authelia/oidc-hmac" = {
          owner = "authelia-main";
        };
        "routing/authelia/oidc-jwks" = {
          owner = "authelia-main";
        };

        "routing/users/admin-user-password" = {
          owner = "lldap";
        };

        "searx/env" = {
          owner = "searx";
        };

        "freshrss/oidc-client-secret" = {
          owner = "traefik";
        };
        "freshrss/oidc-client-secret-hash" = {
          owner = "authelia-main";
        };
        "freshrss/oidc-env" = {};
        "filebrowser/env" = {};
        "filebrowser/oidc-client-secret-hash" = {
          owner = "authelia-main";
        };

        "headplane/cookie-secret" = {
          owner = "headplane";
        };
        "headplane/oidc-client-secret" = {
          owner = "headplane";
        };
        "headplane/oidc-client-secret-hash" = {
          owner = "authelia-main";
        };
        "headscale/api-key" = {
          owner = "headplane";
        };

        "aria2/rpc-token" = {
          owner = "aria2";
        };
      };

      custom.web-expose = {
        enable = true;
        domain = domain;
        email = email;
        traefikEnvFile = config.sops.secrets."routing/traefik/env".path;

        lldap = {
          adminPasswordFile = config.sops.secrets."routing/lldap/admin-password".path;
          jwtSecretFile = config.sops.secrets."routing/lldap/jwt-secret".path;
          keySeedFile = config.sops.secrets."routing/lldap/key-seed".path;

          bootstrap = {
            groups.admins = {
              name = "admins";
            };
            groups.service-users = {
              name = "service-users";
            };
            users.admin = {
              email = email;
              passwordFile = config.sops.secrets."routing/users/admin-user-password".path;
              displayName = "Admin";
              firstName = "Admin";
              lastName = "Admin";
              groups = [
                "admins"
                "service-users"
              ];
            };
          };
        };

        authelia = {
          enable = true;
          secrets = {
            jwtSecretFile = config.sops.secrets."routing/authelia/jwt-secret".path;
            sessionSecretFile = config.sops.secrets."routing/authelia/session-secret".path;
            storageEncryptionKeyFile = config.sops.secrets."routing/authelia/storage-key".path;
          };
          oidc = {
            hmacSecretFile = config.sops.secrets."routing/authelia/oidc-hmac".path;
            jwksRsaKeyFile = config.sops.secrets."routing/authelia/oidc-jwks".path;
          };
        };

        traefikOidcPlugin = {
          enable = true;
          sessionSecretFile = config.sops.secrets."routing/traefik/oidc-session".path;
        };

        routers = {
          searxng = {
            subdomain = "search";
            port = 8889;
            host = "127.0.0.1";
            public = true;
            auth = "two_factor";
            subjects = ["group:service-users"];
          };

          jellyfin = {
            subdomain = "jellyfin";
            port = 8096;
            host = "127.0.0.1";
            public = true;
            auth = null;
          };

          sonarr = {
            subdomain = "sonarr";
            port = 8989;
            host = "127.0.0.1";
            public = false;
            auth = null;
          };

          radarr = {
            subdomain = "radarr";
            port = 7878;
            host = "127.0.0.1";
            public = false;
            auth = null;
          };

          prowlarr = {
            subdomain = "prowlarr";
            port = 9696;
            host = "127.0.0.1";
            public = false;
            auth = null;
          };

          seerr = {
            subdomain = "seerr";
            port = 5055;
            host = "127.0.0.1";
            public = false;
            auth = null;
          };

          qbittorrent-nixflix = {
            subdomain = "qbittorrent-nixflix";
            port = 8282;
            host = "127.0.0.1";
            public = false;
            auth = null;
          };

          freshrss = {
            subdomain = "rss";
            port = 8035;
            public = true;
            auth = null;

            oidc = {
              client_id = "freshrss";
              client_secret_hash_file = config.sops.secrets."freshrss/oidc-client-secret-hash".path;
              redirect_uris = ["https://rss.${domain}:443/i/oidc/"];
              scopes = [
                "openid"
                "profile"
              ];
            };
          };

          filebrowser = {
            subdomain = "files";
            port = 7070;
            public = true;
            auth = null;

            oidc = {
              client_id = "filebrowser";
              client_secret_hash_file = config.sops.secrets."filebrowser/oidc-client-secret-hash".path;
              redirect_uris = ["https://files.${domain}/api/auth/oidc/callback"];
              scopes = [
                "openid"
                "profile"
                "email"
                "groups"
              ];
              token_endpoint_auth_method = "client_secret_basic";
            };
          };

          cockpit = {
            subdomain = "cockpit";
            port = 9090;
            public = true;
            auth = null;
          };

          netdata = {
            subdomain = "netdata";
            port = 19999;
            public = true;
            auth = "two_factor";
            subjects = ["group:service-users"];
          };

          up-snap = {
            subdomain = "up-snap";
            port = 8090;
            public = true;
            auth = "two_factor";
            subjects = ["group:service-users"];
          };

          headscale = {
            subdomain = "tailscale";
            port = 9092;
            host = "127.0.0.1";
            public = true;
            auth = null;
          };

          headplane = {
            subdomain = "headplane";
            port = 4444;
            host = "127.0.0.1";
            public = true;
            auth = null;
            oidc = {
              client_id = "headplane";
              client_secret_hash_file = config.sops.secrets."headplane/oidc-client-secret-hash".path;
              redirect_uris = ["https://headplane.${domain}/admin/oidc/callback"];
              scopes = [
                "openid"
                "profile"
                "email"
                "groups"
              ];
              token_endpoint_auth_method = "client_secret_basic";
            };
          };

          ariang = {
            subdomain = "ariang";
            port = 1357;
            public = true;
            auth = "two_factor";
            subjects = ["group:service-users"];
          };

          qbittorrent = {
            subdomain = "qbittorrent";
            port = 8585;
            host = "127.0.0.1";
            public = true;
            auth = "two_factor";
            subjects = ["group:service-users"];
          };
        };
      };

      virtualisation.oci-containers = {
        backend = "podman";
        containers = {
          freshrss = {
            image = "ghcr.io/freshrss/freshrss:1.29.0";

            environment = {
              TZ = "Europe/Warsaw";
              CRON_MIN = "1,31";
              OIDC_ENABLED = "1";
              OIDC_PROVIDER_METADATA_URL = "https://auth.${domain}/.well-known/openid-configuration";
              OIDC_CLIENT_ID = "freshrss";
              OIDC_SCOPES = "openid profile";
              OIDC_REMOTE_USER_CLAIM = "preferred_username";
              OIDC_X_FORWARDED_HEADERS = "X-Forwarded-Host X-Forwarded-Port X-Forwarded-Proto";
            };

            environmentFiles = [config.sops.secrets."freshrss/oidc-env".path];

            volumes = [
              "/var/lib/freshrss/data:/var/www/FreshRSS/data"
              "/var/lib/freshrss/extensions:/var/www/FreshRSS/extensions"
            ];

            ports = ["127.0.0.1:8035:80"];
          };

          filebrowser = {
            # renovate: versioning=docker
            image = "ghcr.io/gtsteffaniak/filebrowser:1.3.3-stable";

            environment = {
              TZ = "Europe/Warsaw";
            };
            environmentFiles = [
              config.sops.secrets."filebrowser/env".path
            ];

            ports = ["127.0.0.1:7070:80"];

            volumes = [
              "${filebrowserStateDir}:/home/filebrowser/data"
              "/etc/filebrowser-config.yaml:/home/filebrowser/data/config.yaml:ro"
              "/mnt/data:/sources/mnt-data:ro"
              "/var/lib:/sources/var-lib:ro"
            ];
          };

          up-snap = {
            image = "ghcr.io/seriousm4x/upsnap:5.3.5";
            environment = {
              TZ = "Europe/Warsaw";
              UPSNAP_PING_PRIVILEGED = "true";
              UPSNAP_HTTP_LISTEN = "127.0.0.1:8090";
            };

            volumes = ["/var/lib/up-snap:/app/pb_data"];

            extraOptions = [
              "--network=host"
              "--cap-add=NET_RAW"
            ];
          };

          qbittorrent = {
            # renovate: versioning=loose
            image = "lscr.io/linuxserver/qbittorrent:5.2.0_v2.0.12-ls458";
            autoStart = true;

            ports = [
              "8585:8585"
              "6881:6881"
              "6881:6881/udp"
            ];

            environment = {
              PUID = "1000";
              PGID = "1000";
              TZ = "Europe/Warsaw";
              WEBUI_PORT = "8585";
            };

            volumes = [
              "/var/lib/qbittorrent/config:/config"
              "/mnt/storage/qbittorrent/downloads:/downloads"
            ];
          };
        };
      };

      services = {
        redis.servers = {
          searxng = {
            enable = true;
            package = pkgs.valkey;
            bind = "127.0.0.1";
            port = 6380;
          };
        };

        searx = {
          enable = true;
          openFirewall = true;
          settings = {
            server = {
              bind_address = "127.0.0.1";
              port = 8889;
              secret_key = "@SEARX_SECRET_KEY@";
              public_instance = false;
              image_proxy = true;
              base_url = "search.${domain}";
            };
            search = {
              safe_search = 0;
              formats = [
                "html"
                "json"
              ];
            };
            valkey = {
              url = "valkey://127.0.0.1:6380/0";
            };
            engines = [
              {
                name = "wolframalpha";
                engine = "wolframalpha_noapi";
                shortcut = "wa";
                categories = "general";
                disabled = false;
              }
              {
                name = "internet archive";
                engine = "internet_archive";
                shortcut = "ia";
                categories = "files";
                disabled = false;
              }
            ];
          };
          environmentFile = config.sops.secrets."searx/env".path;
          limiterSettings = {
            botdetection = {
              ip_limit = {
                filter_link_local = true;
                link_token = true;
              };
              ip_lists = {
                pass_searxng_org = true;
              };
            };
          };
        };

        netdata = {
          enable = true;

          config = {
            global = {
              "memory mode" = "dbengine";
              "history" = "14";
              "debug log" = "none";
              "access log" = "none";
              "error log" = "syslog";
            };

            web = {
              "bind to" = "localhost";
              "default port" = "19999";
            };
          };
        };

        cockpit = {
          enable = true;
          port = 9090;
          openFirewall = false;

          plugins = [pkgs.cockpit-files];

          settings = {
            WebService = {
              Origins = "https://cockpit.${domain}";
            };
          };
        };

        headscale = {
          enable = true;
          address = "127.0.0.1";
          port = 9092;
          settings = {
            server_url = "https://tailscale.${domain}";
            dns.base_domain = "ts.${domain}";
            dns.magic_dns = true;
            ip_prefixes = [
              "100.64.0.0/10"
              "fd7a:115c:a1e0::/48"
            ];
            logtail.enabled = false;
            derp.server.enabled = false;
          };
        };

        headplane = {
          enable = true;
          settings = {
            server = {
              host = "127.0.0.1";
              port = 4444;
              cookie_secret_path = config.sops.secrets."headplane/cookie-secret".path;
              cookie_secure = true;
              data_path = "/var/lib/headplane";
            };

            headscale = {
              url = "https://tailscale.${domain}";
              config_path = (pkgs.formats.yaml {}).generate "headscale.yml" (
                lib.recursiveUpdate config.services.headscale.settings {
                  tls_cert_path = "/dev/null";
                  tls_key_path = "/dev/null";
                  policy.path = "/dev/null";
                }
              );
              config_strict = true;
              api_key_path = config.sops.secrets."headscale/api-key".path;
            };

            integration.proc.enabled = true;

            oidc = {
              issuer = "https://auth.${domain}";
              client_id = "headplane";
              client_secret_path = config.sops.secrets."headplane/oidc-client-secret".path;
              redirect_uri = "https://headplane.${domain}/admin/oidc/callback";
              token_endpoint_auth_method = "client_secret_basic";
              disable_api_key_login = true;
            };
          };
        };
        aria2 = {
          enable = true;
          downloadDir = "/mnt/storage/aria2/downloads";
          openPorts = true;
          settings = {
            enable-rpc = true;
            rpc-listen-all = true;
            rpc-listen-port = 6800;
          };
          rpcSecretFile = config.sops.secrets."aria2/rpc-token".path;
        };
        nginx = {
          enable = true;
          virtualHosts."localhost" = {
            listen = [
              {
                addr = "127.0.0.1";
                port = 1357;
              }
            ];
            root = "${pkgs.ariang}/share/ariang";
          };
        };
      };

      nixflix = {
        enable = true;

        mediaDir = "/mnt/data/media";
        downloadsDir = "/mnt/data/downloads";
        stateDir = "/var/lib";
        mediaUsers = [username];

        nginx.enable = false;
        caddy.enable = false;

        postgres.enable = true;

        theme.enable = true;

        sonarr = {
          enable = true;
          openFirewall = true;

          config.apiKey = {
            _secret = config.sops.secrets."nixflix/sonarr/api-key".path;
          };
          hostConfig = {
            username = "admin";
            password = {
              _secret = config.sops.secrets."nixflix/sonarr/password".path;
            };
            authenticationMethod = "forms";
            authenticationRequired = "disabledForLocalAddresses";
          };
        };

        radarr = {
          enable = true;
          openFirewall = true;

          config.apiKey = {
            _secret = config.sops.secrets."nixflix/radarr/api-key".path;
          };
          hostConfig = {
            username = "admin";
            password = {
              _secret = config.sops.secrets."nixflix/radarr/password".path;
            };
            authenticationMethod = "forms";
            authenticationRequired = "disabledForLocalAddresses";
          };
        };

        prowlarr = {
          enable = true;
          openFirewall = true;

          config = {
            apiKey = {
              _secret = config.sops.secrets."nixflix/prowlarr/api-key".path;
            };
            indexers = [
              {
                name = "1337x";
                tags = ["flaresolverr"];
              }
              {name = "Nyaa";}
              {
                name = "TorrentGalaxy";
                tags = ["flaresolverr"];
              }
              {
                name = "The Pirate Bay";
                tags = ["flaresolverr"];
              }
              {name = "EZTV";}
              {name = "LimeTorrents";}
            ];
          };
          hostConfig = {
            username = "admin";
            password = {
              _secret = config.sops.secrets."nixflix/prowlarr/password".path;
            };
            authenticationMethod = "forms";
            authenticationRequired = "disabledForLocalAddresses";
          };
        };

        jellyfin = {
          enable = true;
          openFirewall = true;

          apiKey = {
            _secret = config.sops.secrets."nixflix/jellyfin/api-key".path;
          };

          cacheDir = "/var/cache/jellyfin";

          encoding = {
            enableHardwareEncoding = true;
            hardwareAccelerationType = "qsv";
            qsvDevice = "/dev/dri/renderD128";
            hardwareDecodingCodecs = [
              "h264"
              "hevc"
              "mpeg2video"
              "vc1"
              "vp8"
              "vp9"
            ];
            transcodingTempPath = "/var/cache/jellyfin/transcodes";
            enableSubtitleExtraction = true;
            enableIntelLowPowerH264HwEncoder = false;
            enableIntelLowPowerHevcHwEncoder = false;
          };

          system = {
            enableLegacyAuthorization = false;
            serverName = config.networking.hostName;
            cacheSize = 4096;
          };

          libraries = let
            subtitleSettings = {
              subtitleFetcherOrder = [
                "subbuzz"
                "Open Subtitles"
              ];
              subtitleDownloadLanguages = [
                "eng"
                "pl"
              ];
              saveSubtitlesWithMedia = true;
              allowEmbeddedSubtitles = "AllowAll";
              requirePerfectSubtitleMatch = false;
              skipSubtitlesIfAudioTrackMatches = false;
              skipSubtitlesIfEmbeddedsubtitlesPresent = true;
            };
          in {
            Shows = subtitleSettings;
            Anime = subtitleSettings;
            Movies = subtitleSettings;
          };

          plugins = {
            subbuzz = {
              enable = true;
              config = {
                OpenSubUserName = "surface";
                OpenSubPassword._secret = config.sops.secrets."nixflix/opensubtitles-com/password".path;
                OpenSubApiKey._secret = config.sops.secrets."nixflix/opensubtitles-com/api-key".path;
                EnableOpenSubtitles = true;
                EnableYifySubtitles = true;
                EnablePodnapisiNet = true;
                EnableSubSource = true;
                SubSourceApiKey._secret = config.sops.secrets."nixflix/subsource/api-key".path;
                EnableSubdlCom = true;
                SubdlApiKey._secret = config.sops.secrets."nixflix/subdl/api-key".path;
              };
            };

            "Open Subtitles" = {
              enable = true;
              config = {
                Username = "surface";
                Password._secret = config.sops.secrets."nixflix/opensubtitles-com/password".path;
              };
            };
            "Subtitle Extract" = {
              enable = true;
              config.ExtractionDuringLibraryScan = true;
            };
          };

          users = {
            admin = {
              password = {
                _secret = config.sops.secrets."nixflix/jellyfin/users/admin-password".path;
              };
              policy = {
                isAdministrator = true;
                enableContentDeletion = true;
                enableSubtitleManagement = true;
              };
              configuration = {
                subtitleMode = "Smart";
                enableNextEpisodeAutoPlay = true;
              };
              mutable = false;
            };
            user1 = {
              password = {
                _secret = config.sops.secrets."nixflix/jellyfin/users/user1-password".path;
              };
              policy = {
                isAdministrator = false;
                enableContentDeletion = false;
                enableSubtitleManagement = false;
              };
              configuration = {
                subtitleMode = "Smart";
                enableNextEpisodeAutoPlay = true;
              };
              mutable = false;
            };
            user2 = {
              password = {
                _secret = config.sops.secrets."nixflix/jellyfin/users/user2-password".path;
              };
              policy = {
                isAdministrator = false;
                enableContentDeletion = false;
                enableSubtitleManagement = false;
              };
              configuration = {
                subtitleMode = "Smart";
                enableNextEpisodeAutoPlay = true;
              };
              mutable = false;
            };
          };
        };

        seerr = {
          enable = true;
          openFirewall = true;
          port = 5055;

          apiKey = {
            _secret = config.sops.secrets."nixflix/seerr/api-key".path;
          };
        };

        torrentClients.qbittorrent = {
          enable = true;
          webuiPort = 8282;

          password = {
            _secret = config.sops.secrets."nixflix/qbittorrent/password".path;
          };
        };

        flaresolverr = {
          enable = true;
          port = 8191;
        };

        recyclarr = {
          enable = true;
          radarrQuality = "1080p";
          sonarrQuality = "1080p";
          cleanupUnmanagedProfiles = {
            enable = true;
          };
        };

        downloadarr = {
          enable = true;
        };
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          libvdpau-va-gl
        ];
      };

      users.users.jellyfin.extraGroups = [
        "video"
        "render"
      ];

      systemd = {
        tmpfiles.rules = [
          "d /var/lib/freshrss/data       0750 root root -"
          "d /var/lib/freshrss/extensions 0750 root root -"
          "d ${filebrowserStateDir} 0700 1000 1000 -"
          "d /var/lib/headplane 0750 headplane headplane -"
          "d /mnt/storage/aria2 0755 aria2 aria2 - -"
          "d /mnt/storage/aria2/downloads 0755 aria2 aria2 - -"
          "d /var/lib/qbittorrent/config 0755 1000 1000 -"
        ];
        mounts."var-cache-jellyfin" = {
          what = "tmpfs";
          where = "/var/cache/jellyfin";
          type = "tmpfs";
          options = "size=4G,mode=0755,uid=146,gid=146";
          before = ["jellyfin.service"];
          wantedBy = ["multi-user.target"];
        };
        services.duckdns-updater = {
          description = "Update DuckDNS IP";
          path = [pkgs.curl];

          serviceConfig = {
            Type = "oneshot";
            EnvironmentFile = config.sops.secrets."routing/traefik/env".path;
          };

          script = ''
            curl -s "https://www.duckdns.org/update" --url-query "domains=${domain}" --url-query "token=$DUCKDNS_TOKEN"
          '';
        };
        timers.duckdns-updater = {
          wantedBy = ["timers.target"];
          timerConfig = {
            OnBootSec = "1m";
            OnUnitActiveSec = "15m";
            RandomizedDelaySec = "1m";
          };
        };
      };
      environment.etc = {
        "filebrowser-config.yaml".text = ''
          server:
            port: 80
            database: "/home/filebrowser/data/database.db"
            cacheDir: "/home/filebrowser/data/tmp"
          sources:
            - path: "/sources/mnt-data"
              config:
                defaultEnabled: true
            - path: "/sources/var-lib"
              config:
                defaultEnabled: true
          auth:
            methods:
              password:
                enabled: true
              oidc:
                enabled: true
                clientId: "filebrowser"
                issuerUrl: "https://auth.${domain}"
                scopes: "openid email profile groups"
                userIdentifier: "preferred_username"
        '';
      };

      networking.firewall = {
        allowedTCPPorts = [6881];
        allowedUDPPorts = [
          41641
          6881
        ];
        trustedInterfaces = ["tailscale0"];
      };
    };
  };
}
