{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.nixflix = {
      config,
      pkgs,
      ...
    }: {
      imports = [
        inputs.nixflix.nixosModules.default
        self.nixosModules.web-expose
      ];

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
      };

      custom.web-expose.routers = {
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
      };

      nixflix = {
        enable = true;

        mediaDir = "/mnt/data/media";
        downloadsDir = "/mnt/data/downloads";
        stateDir = "/var/lib";
        mediaUsers = [config.custom.user.name];

        nginx.enable = false;
        caddy.enable = false;

        postgres.enable = true;

        theme.enable = true;

        sonarr = {
          enable = true;
          openFirewall = true;

          config = {
            apiKey = {
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
        };

        radarr = {
          enable = true;
          openFirewall = true;

          config = {
            apiKey = {
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
            hostConfig = {
              username = "admin";
              password = {
                _secret = config.sops.secrets."nixflix/prowlarr/password".path;
              };
              authenticationMethod = "forms";
              authenticationRequired = "disabledForLocalAddresses";
            };
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
              skipSubtitlesIfEmbeddedSubtitlesPresent = true;
            };
          in {
            Shows = subtitleSettings;
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
        mounts = [
          {
            what = "tmpfs";
            where = "/var/cache/jellyfin";
            type = "tmpfs";
            options = "size=4G,mode=0755,uid=146,gid=146";
            before = ["jellyfin.service"];
            wantedBy = ["multi-user.target"];
          }
        ];
      };

      networking.firewall = {
        allowedTCPPorts = [6881];
        allowedUDPPorts = [6881];
      };
    };
  };
}
