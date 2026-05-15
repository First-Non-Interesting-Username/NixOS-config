{ ... }:
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
        sops.secrets = {
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

        home-manager.users.${username} =
          { ... }:
          {
            # Home config goes here
          };
      };
  };
}
