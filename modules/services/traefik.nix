{...}: {
  flake = {
    nixosModules.traefik = {
      lib,
      config,
      gitEmail,
      ...
    }: let
      cfg = config.custom.traefik-expose;
    in {
      options.custom.traefik-expose = {
        enable = lib.mkEnableOption "Traefik";
        baseDomain = lib.mkOption {
          type = lib.types.str;
          example = "mydomain.duckdns.org";
          description = "Your base domain";
        };

        hosts = lib.mkOption {
          type = lib.types.attrsOf (
            lib.types.submodule {
              options = {
                subdomain = lib.mkOption {
                  type = lib.types.str;
                  example = "jellyfin";
                  description = "Subdomain name (e.g., 'jellyfin' -> jellyfin.mydomain.duckdns.org)";
                };
                localHost = lib.mkOption {
                  type = lib.types.str;
                  default = "127.0.0.1";
                  description = "IP or hostname where the local service listens";
                };
                localPort = lib.mkOption {
                  type = lib.types.port;
                  example = 8080;
                  description = "Port where the local service listens";
                };
                public = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = ''
                    Whether the service is reachable from the internet.
                    - true  → no IP restriction
                    - false → LAN-only (192.168.0.0/16, 10.0.0.0/8, 172.16.0.0/12)
                  '';
                };
              };
            }
          );
          default = {};
          description = "Services to expose via Traefik";
        };
      };

      config = lib.mkIf cfg.enable {
        sops.secrets.traefik_env = {
          owner = "traefik";
        };
        services.traefik = {
          environmentFiles = [config.sops.secrets.traefik_env.path];

          staticConfigOptions = {
            entryPoints = {
              web = {
                address = ":80";
                http.redirections.entryPoint = {
                  to = "websecure";
                  scheme = "https";
                };
              };
              websecure.address = ":443";
            };
            certificatesResolvers.duckdns.acme = {
              email = gitEmail;
              storage = "/var/lib/traefik/acme.json";
              dnsChallenge = {
                provider = "duckdns";
                resolvers = [
                  "1.1.1.1:53"
                  "8.8.8.8:53"
                ];
              };
            };
            ping = {};
          };

          dynamicConfigOptions = {
            tls.options.default = {
              sniStrict = true;
              minVersion = "VersionTLS12";
              cipherSuites = [
                "TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256"
                "TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384"
                "TLS_ECDHE_RSA_WITH_CHACHA20_POLY1305"
                "TLS_AES_128_GCM_SHA256"
                "TLS_AES_256_GCM_SHA384"
                "TLS_CHACHA20_POLY1305_SHA256"
              ];
              curvePreferences = [
                "CurveP521"
                "CurveP384"
              ];
            };

            http = {
              middlewares = {
                lan-only.ipAllowList.sourceRange = [
                  "192.168.0.0/16"
                  "10.0.0.0/8"
                  "172.16.0.0/12"
                ];
                public-ratelimit.rateLimit = {
                  average = 100;
                  burst = 100;
                };
                security-headers.headers = {
                  hostsProxyHeaders = ["X-Forwarded-Host"];
                  stsSeconds = 63072000;
                  stsIncludeSubdomains = true;
                  stsPreload = true;
                  forceSTSHeader = true;
                  customFrameOptionsValue = "SAMEORIGIN";
                  browserXssFilter = true;
                  referrerPolicy = "same-origin";
                  permissionsPolicy = "camera=(), microphone=(), geolocation=(), payment=(), usb=(), vr=()";
                  customResponseHeaders = {
                    X-Robots-Tag = "none,noarchive,nosnippet,notranslate,noimageindex,";
                    server = "";
                  };
                };
                public.chain.middlewares = [
                  "public-ratelimit"
                  "security-headers"
                ];
              };

              routers =
                lib.mapAttrs (name: svc: {
                  rule = "Host(`${svc.subdomain}.${cfg.baseDomain}`)";
                  entryPoints = ["websecure"];
                  service = name;
                  tls = {
                    certResolver = "duckdns";
                    options = "default";
                  };
                  middlewares =
                    if svc.public
                    then ["public"]
                    else ["lan-only"];
                })
                cfg.hosts;

              services =
                lib.mapAttrs (_name: svc: {
                  loadBalancer.servers = [
                    {url = "http://${svc.localHost}:${builtins.toString svc.localPort}";}
                  ];
                })
                cfg.hosts;
            };
          };
        };
      };
    };
  };
}
