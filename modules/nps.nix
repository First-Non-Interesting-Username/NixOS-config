{
  self,
  inputs,
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
        };
      };
  };
}
