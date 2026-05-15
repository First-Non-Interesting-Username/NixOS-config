{ inputs, ... }:
{
  flake = {
    nixosModules.home-server-iroh =
      {
        lib,
        username,
        impermanence,
        config,
        pkgs,
        ...
      }:
      let
        domain = "iameasytoremember.duckdns.org";
        email = "janekmusin@proton.me";
      in
      {
        imports = [
          inputs.nixflix.nixosModules.default
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [ "/var/lib" ];
          };
        };

        sops.secrets = {
          "nixflix/sonarr/api-key" = {
            owner = "sonarr";
          };

          "nixflix/radarr/api-key" = {
            owner = "radarr";
          };

          "nixflix/prowlarr/api-key" = {
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
              users.alice = {
                email = email;
                passwordFile = config.sops.secrets."routing/users/admin-user-password".path;
                displayName = "Admin";
                firstName = "Admin";
                lastName = "Admin";
                groups = [ "admins" ];
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
              subjects = [ "group:searx-users" ];
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

            qbittorrent = {
              subdomain = "qbittorrent";
              port = 8282;
              host = "127.0.0.1";
              public = false;
              auth = null;
            };
          };
        };

        services = {

          redis.servers.searxng = {
            enable = true;
            package = pkgs.valkey;
            bind = "127.0.0.1";
            port = 6380;
          };

          searx = {
            enable = true;
            settings = {
              server = {
                bind_address = "127.0.0.1";
                port = 8889;
                secret_key = "@SEARX_SECRET_KEY@";
                public_instance = false;
                image_proxy = true;
                base_url = "search.${domain}";
                default_http_headers = {
                  "X-Content-Type-Options" = "nosniff";
                  "X-Download-Options" = "noopen";
                  "X-Robots-Tag" = "noindex, nofollow";
                  "Referrer-Policy" = "no-referrer";
                };
              };
              search.safe_search = 0;
              valkey = {
                url = "valkey://127.0.0.1:6380/0";
              };
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

        };

        nixflix = {
          enable = true;

          mediaDir = "/mnt/data/media";
          downloadsDir = "/mnt/data/downloads";
          stateDir = "/var/lib";
          mediaUsers = [ username ];

          nginx.enable = false;
          caddy.enable = false;

          postgres.enable = true;

          theme.enable = true;

          sonarr = {
            enable = true;
            openFirewall = false;

            config.apiKey = {
              _secret = config.sops.secrets."nixflix/sonarr/api-key".path;
            };
          };

          radarr = {
            enable = true;
            openFirewall = false;

            config.apiKey = {
              _secret = config.sops.secrets."nixflix/radarr/api-key".path;
            };
          };

          prowlarr = {
            enable = true;
            openFirewall = false;

            config = {
              apiKey = {
                _secret = config.sops.secrets."nixflix/prowlarr/api-key".path;
              };
              indexers = [
                { name = "1337x"; }
                { name = "Nyaa"; }
                { name = "TorrentGalaxy"; }
                { name = "The Pirate Bay"; }
                { name = "EZTV"; }
                { name = "LimeTorrents"; }
              ];
            };
          };

          jellyfin = {
            enable = true;
            openFirewall = false;

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

            libraries =
              let
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
              in
              {
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
            openFirewall = false;
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

        systemd.mounts."var-cache-jellyfin" = {
          what = "tmpfs";
          where = "/var/cache/jellyfin";
          type = "tmpfs";
          options = "size=4G,mode=0755,uid=146,gid=146";
          before = [ "jellyfin.service" ];
          wantedBy = [ "multi-user.target" ];
        };

        home-manager.users.${username} =
          { ... }:
          {
            # Home config goes here
          };
      };
  };
}
