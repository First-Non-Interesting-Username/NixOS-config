{self, ...}: {
  flake.nixosModules.web-expose = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.custom.web-expose;

    routerAuth = r:
      if r.oidcPlugin != null && r.oidcPlugin.enable
      then null
      else if r.auth != null
      then r.auth
      else if r.public
      then cfg.authelia.defaultPolicy
      else null;

    effectiveRouters = lib.mapAttrs (name: r: r // {auth = routerAuth r;}) cfg.routers;

    authRouters = lib.filterAttrs (_: r: r.auth != null) effectiveRouters;
    oidcRouters = lib.filterAttrs (_: r: r.oidc != null) effectiveRouters;
    oidcPluginRouters =
      lib.filterAttrs (
        _: r: r.oidcPlugin != null && r.oidcPlugin.enable
      )
      effectiveRouters;
    anyAuth = authRouters != {};
    anyOidc = oidcRouters != {};
    anyOidcPlugin = oidcPluginRouters != {};

    lldapBootstrap = let
      configHash = builtins.hashString "sha256" (builtins.toJSON {
        groups = cfg.lldap.bootstrap.groups;
        users = cfg.lldap.bootstrap.users;
      });
    in
      pkgs.writeShellScript "lldap-bootstrap" ''
        set -euo pipefail
        MARKER="/var/lib/lldap/bootstrapped"
        CURRENT_HASH="${configHash}"

        if [ -f "$MARKER" ] && [ "$(cat "$MARKER")" = "$CURRENT_HASH" ]; then
          echo "LLDAP already bootstrapped with current configuration. Skipping."
          exit 0
        fi

        API="http://127.0.0.1:17170/graphql"
        ADMIN_USER="${cfg.lldap.adminUsername}"
        ADMIN_PASS="$(${pkgs.coreutils}/bin/cat "${cfg.lldap.adminPasswordFile}")"

        for i in $(seq 1 60); do
          if ${pkgs.curl}/bin/curl -sf "$API" -X POST \
            -H "Content-Type: application/json" \
            -d "$(${pkgs.jq}/bin/jq -n '{query: "{ __typename }"}')" >/dev/null 2>&1; then
            break
          fi
          ${pkgs.coreutils}/bin/sleep 1
        done

        TOKEN_RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
          -H "Content-Type: application/json" \
          -d "$(${pkgs.jq}/bin/jq -n \
            --arg username "$ADMIN_USER" \
            --arg password "$ADMIN_PASS" \
            '{query: "mutation { bind(input: {username: \($username | @json), password: \($password | @json)}) { ok token } }"}')")
        if echo "$TOKEN_RESP" | ${pkgs.jq}/bin/jq -e '.errors' >/dev/null; then
          echo "Login failed: $(echo "$TOKEN_RESP" | ${pkgs.jq}/bin/jq -c '.errors')" >&2
          exit 1
        fi
        TOKEN=$(echo "$TOKEN_RESP" | ${pkgs.jq}/bin/jq -r '.data.bind.token')

        refresh_groups() {
          GROUPS_JSON=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $TOKEN" \
            -d "$(${pkgs.jq}/bin/jq -n '{query: "query { groups { id name } }"}')")
          if echo "$GROUPS_JSON" | ${pkgs.jq}/bin/jq -e '.errors' >/dev/null; then
            echo "Failed to fetch groups: $GROUPS_JSON" >&2
            exit 1
          fi
        }
        get_group_id() {
          echo "$GROUPS_JSON" | ${pkgs.jq}/bin/jq -r --arg name "$1" '.data.groups[] | select(.name == $name) | .id'
        }

        refresh_groups

        ${lib.concatMapStrings (g: ''
          GID=$(get_group_id "${g.name}")
          if [ -z "$GID" ]; then
            echo "Creating group ${g.name}..."
            RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer $TOKEN" \
              -d "$(${pkgs.jq}/bin/jq -n \
                --arg name "${g.name}" \
                '{query: "mutation CreateGroup($name: String!) { createGroup(name: $name) { ok } }", variables: {name: $name}}')")
            if echo "$RESP" | ${pkgs.jq}/bin/jq -e '.errors or (.data.createGroup.ok | not)' >/dev/null; then
              echo "Failed to create group ${g.name}: $RESP" >&2
              exit 1
            fi
            refresh_groups
          fi
        '') (lib.attrValues cfg.lldap.bootstrap.groups)}

        ${lib.concatMapStrings (u: ''
          ${lib.optionalString (u.passwordFile != null) ''
            USER_PASS=$(${pkgs.coreutils}/bin/cat "${toString u.passwordFile}")
          ''}

          # Check if user exists
          USER_EXISTS_RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $TOKEN" \
            -d "$(${pkgs.jq}/bin/jq -n \
              --arg id "${u.id}" \
              '{query: "query GetUser($id: String!) { user(userId: $id) { id } }", variables: {id: $id}}')")

          if echo "$USER_EXISTS_RESP" | ${pkgs.jq}/bin/jq -e '.errors' >/dev/null; then
            echo "Failed to check user existence for ${u.id}: $USER_EXISTS_RESP" >&2
            exit 1
          fi

          USER_EXISTS=$(echo "$USER_EXISTS_RESP" | ${pkgs.jq}/bin/jq -r '.data.user.id // empty')

          if [ -z "$USER_EXISTS" ]; then
            echo "Creating user ${u.id}..."
            USER_VARS=$(${pkgs.jq}/bin/jq -n \
              --arg id "${u.id}" \
              --arg email "${u.email}" \
              ${lib.optionalString (u.displayName != null) ''--arg displayName "${u.displayName}"''} \
              ${lib.optionalString (u.firstName != null) ''--arg firstName "${u.firstName}"''} \
              ${lib.optionalString (u.lastName != null) ''--arg lastName "${u.lastName}"''} \
              ${lib.optionalString (u.passwordFile != null) ''--arg password "$USER_PASS"''} \
              '{
                id: $id,
                email: $email
                ${lib.optionalString (u.displayName != null) ", displayName: $displayName"}
                ${lib.optionalString (u.firstName != null) ", firstName: $firstName"}
                ${lib.optionalString (u.lastName != null) ", lastName: $lastName"}
                ${lib.optionalString (u.passwordFile != null) ", password: $password"}
              }')

            RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
              -H "Content-Type: application/json" \
              -H "Authorization: Bearer $TOKEN" \
              -d "$(${pkgs.jq}/bin/jq -n \
                --arg query 'mutation CreateUser($user: CreateUserInput!) { createUser(user: $user) { ok } }' \
                --argjson user "$USER_VARS" \
                '{query: $query, variables: {user: $user}}')")

            if echo "$RESP" | ${pkgs.jq}/bin/jq -e '.errors or (.data.createUser.ok | not)' >/dev/null; then
              echo "Failed to create user ${u.id}: $RESP" >&2
              exit 1
            fi
          fi

          # Get current user groups to avoid duplicate additions
          CURRENT_USER_GROUPS_RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
            -H "Content-Type: application/json" \
            -H "Authorization: Bearer $TOKEN" \
            -d "$(${pkgs.jq}/bin/jq -n \
              --arg id "${u.id}" \
              '{query: "query GetUserGroups($id: String!) { user(userId: $id) { groups { name } } }", variables: {id: $id}}')")

          if echo "$CURRENT_USER_GROUPS_RESP" | ${pkgs.jq}/bin/jq -e '.errors' >/dev/null; then
            echo "Failed to fetch groups for user ${u.id}: $CURRENT_USER_GROUPS_RESP" >&2
            exit 1
          fi

          CURRENT_USER_GROUPS=$(echo "$CURRENT_USER_GROUPS_RESP" | ${pkgs.jq}/bin/jq -r '.data.user.groups[].name')

          ${lib.concatMapStrings (g: ''
              if ! echo "$CURRENT_USER_GROUPS" | grep -qxw "${g}" >/dev/null; then
                GID=$(get_group_id "${g}")
                if [ -n "$GID" ]; then
                  echo "Adding user ${u.id} to group ${g}..."
                  ADD_RESP=$(${pkgs.curl}/bin/curl -sf -X POST "$API" \
                    -H "Content-Type: application/json" \
                    -H "Authorization: Bearer $TOKEN" \
                    -d "$(${pkgs.jq}/bin/jq -n \
                      --arg query 'mutation AddUserToGroup($userId: String!, $groupId: Int!) { addUserToGroup(userId: $userId, groupId: $groupId) { ok } }' \
                      --arg userId "${u.id}" \
                      --argjson groupId "$GID" \
                      '{query: $query, variables: {userId: $userId, groupId: $groupId}}')")
                  if echo "$ADD_RESP" | ${pkgs.jq}/bin/jq -e '.errors or (.data.addUserToGroup.ok | not)' >/dev/null; then
                    echo "Failed to add ${u.id} to group ${g}: $ADD_RESP" >&2
                    exit 1
                  fi
                else
                  echo "Warning: group ${g} not found for user ${u.id}" >&2
                fi
              fi
            '')
            u.groups}
        '') (lib.attrValues cfg.lldap.bootstrap.users)}

        echo "$CURRENT_HASH" > "$MARKER"
      '';

    oidcClientsTemplate = pkgs.writeText "oidc-clients-template.json" (
      builtins.toJSON (
        map (
          r: let
            o = r.oidc;
          in {
            inherit
              (o)
              client_id
              scopes
              grant_types
              response_types
              token_endpoint_auth_method
              consent_mode
              ;
            redirect_uris =
              o.redirect_uris
              ++ lib.optionals (r.oidcPlugin != null && r.oidcPlugin.enable) [
                "https://${r.subdomain}.${cfg.domain}/oauth2/callback"
              ];
          }
        ) (lib.attrValues oidcRouters)
      )
    );

    oidcPluginEnvGen = pkgs.writeShellScript "traefik-oidc-env" ''
      set -euo pipefail
      mkdir -p /var/lib/traefik
      ENV_FILE="/var/lib/traefik/oidc-plugin.env"
      install -m 600 -o traefik -g traefik /dev/null "$ENV_FILE"
      {
        echo "TRAEFIK_OIDC_SESSION_SECRET=$(${pkgs.coreutils}/bin/cat "${cfg.traefikOidcPlugin.sessionSecretFile}")"
        ${lib.concatStrings (
        lib.mapAttrsToList (name: r: ''
          echo "TRAEFIK_OIDC_CLIENT_SECRET_${
            lib.replaceStrings ["-"] ["_"] (lib.toUpper name)
          }=$(${pkgs.coreutils}/bin/cat "${r.oidcPlugin.clientSecretFile}")"
        '')
        oidcPluginRouters
      )}
      } > "$ENV_FILE"
    '';
  in {
    options.custom.web-expose = {
      enable = lib.mkEnableOption "unified Traefik + Authelia + LLDAP web exposure";

      domain = lib.mkOption {
        type = lib.types.str;
        description = "Base domain for all exposed services (e.g. example.com).";
      };

      email = lib.mkOption {
        type = lib.types.str;
        description = "Contact email for ACME certificate registration with Let's Encrypt.";
      };

      traefikEnvFile = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path to an environment file containing DNS provider tokens and other Traefik secrets.
          Must be readable by the traefik user (and ideally owned by traefik with mode 0400).
        '';
      };

      dnsChallenge = {
        provider = lib.mkOption {
          type = lib.types.str;
          default = "duckdns";
          description = "ACME DNS challenge provider (e.g. duckdns, cloudflare, route53).";
        };
      };

      privateNetworkRanges = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [
          "192.168.0.0/16"
          "10.0.0.0/8"
          "172.16.0.0/12"
          "100.64.0.0/10"
        ];
        description = "IP ranges allowed by the lan-only middleware.";
      };

      hstsSeconds = lib.mkOption {
        type = lib.types.int;
        default = 2592000;
        description = "HSTS max-age in seconds. Set to 0 to disable HSTS.";
      };

      traefikOidcPlugin = {
        enable = lib.mkEnableOption "traefik-oidc-auth plugin (OIDC Relying Party)";

        version = lib.mkOption {
          type = lib.types.str;
          default = "v0.18.0";
          description = "Plugin version from the Traefik plugin catalog.";
        };

        sessionSecretFile = lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = ''
            Path to a file containing a 32+ byte random secret for encrypting plugin sessions.
            Required when the plugin is enabled. Must be readable by the traefik user.
          '';
        };
      };

      authelia = {
        enable =
          lib.mkEnableOption "Authelia authentication server"
          // {
            default = anyAuth || anyOidc || anyOidcPlugin;
          };

        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "auth";
          description = "Subdomain for the Authelia web portal.";
        };

        defaultPolicy = lib.mkOption {
          type = lib.types.enum [
            "one_factor"
            "two_factor"
          ];
          default = "two_factor";
          description = "Default Authelia policy for public routers when auth is not explicitly set.";
        };

        sessionProvider = lib.mkOption {
          type = lib.types.enum [
            "memory"
            "valkey"
          ];
          default = "valkey";
          description = "Session storage backend for Authelia.";
        };

        secrets = {
          jwtSecretFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to Authelia JWT secret file. Must be readable by the authelia-main user.";
          };
          sessionSecretFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to Authelia session secret file. Must be readable by the authelia-main user.";
          };
          storageEncryptionKeyFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to Authelia storage encryption key file. Must be readable by the authelia-main user.";
          };
        };

        oidc = {
          enable =
            lib.mkEnableOption "Authelia as an OIDC Provider"
            // {
              default = anyOidc || anyOidcPlugin;
            };

          hmacSecretFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to OIDC HMAC secret file. Must be readable by the authelia-main user.";
          };

          jwksRsaKeyFile = lib.mkOption {
            type = lib.types.path;
            description = "Path to OIDC JWKS RSA private key file (PEM). Must be readable by the authelia-main user.";
          };
        };
      };

      lldap = {
        enable =
          lib.mkEnableOption "LLDAP directory server"
          // {
            default = cfg.authelia.enable;
          };

        subdomain = lib.mkOption {
          type = lib.types.str;
          default = "ldap";
          description = "Subdomain for the LLDAP web UI.";
        };

        adminUsername = lib.mkOption {
          type = lib.types.str;
          default = "admin";
          description = "LLDAP admin username.";
        };

        adminPasswordFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to LLDAP admin password file. Must be readable by the lldap user.";
        };

        jwtSecretFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to LLDAP JWT secret file. Must be readable by the lldap user.";
        };

        keySeedFile = lib.mkOption {
          type = lib.types.path;
          description = "Path to LLDAP key seed file. Must be readable by the lldap user.";
        };

        baseDn = lib.mkOption {
          type = lib.types.str;
          default = "DC=example,DC=com";
          description = "LDAP base DN.";
        };

        bootstrap = {
          enable =
            lib.mkEnableOption "automatic LLDAP user and group bootstrap"
            // {
              default = cfg.lldap.bootstrap.users != {};
            };

          users = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule (
                {name, ...}: {
                  options = {
                    id = lib.mkOption {
                      type = lib.types.str;
                      default = name;
                      description = "User login ID.";
                    };
                    email = lib.mkOption {
                      type = lib.types.str;
                      description = "User email address.";
                    };
                    passwordFile = lib.mkOption {
                      type = lib.types.nullOr lib.types.path;
                      default = null;
                      description = ''
                        Path to a file containing the user's plaintext password.
                        Required to log in. Must be readable by the lldap user.
                      '';
                    };
                    displayName = lib.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      default = null;
                      description = "User display name.";
                    };
                    firstName = lib.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      default = null;
                      description = "User first name.";
                    };
                    lastName = lib.mkOption {
                      type = lib.types.nullOr lib.types.str;
                      default = null;
                      description = "User last name.";
                    };
                    groups = lib.mkOption {
                      type = lib.types.listOf lib.types.str;
                      default = [];
                      description = "List of group names to add the user to. Groups are created before users.";
                    };
                  };
                }
              )
            );
            default = {};
            description = "Attribute set of users to create in LLDAP on first startup.";
          };

          groups = lib.mkOption {
            type = lib.types.attrsOf (
              lib.types.submodule (
                {name, ...}: {
                  options = {
                    name = lib.mkOption {
                      type = lib.types.str;
                      default = name;
                      description = "Group name.";
                    };
                  };
                }
              )
            );
            default = {};
            description = "Attribute set of groups to create in LLDAP on first startup.";
          };
        };
      };

      routers = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule (
            {
              name,
              config,
              ...
            }: {
              options = {
                subdomain = lib.mkOption {
                  type = lib.types.str;
                  description = "Subdomain for this service (e.g. myapp becomes myapp.example.com).";
                };
                port = lib.mkOption {
                  type = lib.types.port;
                  description = "Local port the upstream service listens on.";
                };
                host = lib.mkOption {
                  type = lib.types.str;
                  default = "127.0.0.1";
                  description = "Host address of the upstream service.";
                };
                public = lib.mkOption {
                  type = lib.types.bool;
                  default = false;
                  description = ''
                    true  → exposed to the internet (gets public middleware + auth by default).
                    false → LAN-only (gets lan-only middleware, no auth by default).
                  '';
                };
                auth = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.enum [
                      "bypass"
                      "one_factor"
                      "two_factor"
                      "deny"
                    ]
                  );
                  default = null;
                  description = ''
                    Authelia ForwardAuth policy for this router.
                    - null     → use default (auth for public, none for private).
                    - bypass   → skip auth (explicit opt-out for public services).
                    - one_factor / two_factor / deny → explicit policy.
                    Must be null when oidcPlugin is enabled.
                  '';
                };
                subjects = lib.mkOption {
                  type = lib.types.listOf (lib.types.either lib.types.str (lib.types.listOf lib.types.str));
                  default = [];
                  description = "Authelia access control subjects (e.g. user:alice or group:admins).";
                };
                resources = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [];
                  description = "Authelia access control resource patterns.";
                };
                networks = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [];
                  description = "Authelia access control source networks.";
                };
                methods = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [];
                  description = "Authelia access control HTTP methods.";
                };
                bypassPaths = lib.mkOption {
                  type = lib.types.listOf lib.types.str;
                  default = [];
                  description = ''
                    Authelia path regex patterns to bypass authentication.
                    These are evaluated before the main auth rule, with no subject restrictions.
                  '';
                };
                traefikRule = lib.mkOption {
                  type = lib.types.str;
                  default = "Host(`${config.subdomain}.${cfg.domain}`)";
                  description = "Custom Traefik router rule. Overrides the default Host() match.";
                };
                healthCheck = {
                  enable =
                    lib.mkEnableOption "backend health check"
                    // {
                      default = false;
                    };
                  path = lib.mkOption {
                    type = lib.types.str;
                    default = "/";
                    description = "Health check HTTP path.";
                  };
                  interval = lib.mkOption {
                    type = lib.types.str;
                    default = "10s";
                    description = "Health check interval.";
                  };
                };
                oidc = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        client_id = lib.mkOption {
                          type = lib.types.str;
                          default = name;
                          description = "OIDC client ID registered in Authelia.";
                        };
                        client_secret_hash_file = lib.mkOption {
                          type = lib.types.path;
                          description = ''
                            Path to a file containing the PBKDF2 hash of the OIDC client secret.
                            Generate with:
                              nix run nixpkgs#authelia -- crypto hash generate pbkdf2 --no-confirm --password "SECRET"
                            Must be readable by the authelia-main user.
                          '';
                        };
                        redirect_uris = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          description = "Allowed OIDC redirect URIs. The plugin callback is injected automatically when oidcPlugin is used.";
                        };
                        scopes = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          default = [
                            "openid"
                            "profile"
                            "email"
                          ];
                          description = "OIDC scopes.";
                        };
                        grant_types = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          default = ["authorization_code"];
                          description = "OIDC grant types.";
                        };
                        response_types = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          default = ["code"];
                          description = "OIDC response types.";
                        };
                        token_endpoint_auth_method = lib.mkOption {
                          type = lib.types.str;
                          default = "client_secret_post";
                          description = "OIDC token endpoint authentication method.";
                        };
                        consent_mode = lib.mkOption {
                          type = lib.types.str;
                          default = "auto";
                          description = "OIDC consent mode.";
                        };
                      };
                    }
                  );
                  default = null;
                  description = "Register this router as an OIDC client in Authelia for native OIDC applications.";
                };
                oidcPlugin = lib.mkOption {
                  type = lib.types.nullOr (
                    lib.types.submodule {
                      options = {
                        enable = lib.mkEnableOption "OIDC plugin authentication for this router";
                        clientId = lib.mkOption {
                          type = lib.types.str;
                          default =
                            if config.oidc != null
                            then config.oidc.client_id
                            else name;
                          description = "OIDC client ID registered in Authelia. Defaults to the router's oidc.client_id or the router name.";
                        };
                        clientSecretFile = lib.mkOption {
                          type = lib.types.path;
                          description = ''
                            Path to a file containing the plaintext OIDC client secret.
                            Must be readable by the traefik user.
                            Generate the same secret's PBKDF2 hash for Authelia's client_secret_hash_file.
                          '';
                        };
                        scopes = lib.mkOption {
                          type = lib.types.listOf lib.types.str;
                          default = [
                            "openid"
                            "profile"
                            "email"
                          ];
                          description = "OIDC scopes requested by the plugin.";
                        };
                        usePkce = lib.mkOption {
                          type = lib.types.bool;
                          default = true;
                          description = "Enable PKCE for the authorization code flow.";
                        };
                      };
                    }
                  );
                  default = null;
                  description = "Use the traefik-oidc-auth plugin for apps without native OIDC support.";
                };
              };
            }
          )
        );
        default = {};
        description = "Attribute set of services to expose through Traefik.";
      };
    };

    config = lib.mkIf cfg.enable (
      lib.mkMerge [
        {
          assertions = [
            {
              assertion = cfg.authelia.enable || !anyAuth;
              message = "custom.web-expose: routers request authentication but authelia.enable is false. Either enable authelia or set auth = null/bypass on all routers.";
            }
            {
              assertion = lib.all (r: !(r.oidc != null && r.auth != null && r.auth != "bypass")) (
                lib.attrValues effectiveRouters
              );
              message = "custom.web-expose: routers with OIDC must set auth = 'bypass' or null to avoid double authentication loops.";
            }
            {
              assertion = !anyOidc || cfg.authelia.oidc.enable;
              message = "custom.web-expose: routers have oidc configured but authelia.oidc.enable is false.";
            }
            {
              assertion = !anyOidcPlugin || cfg.authelia.oidc.enable;
              message = "custom.web-expose: routers use oidcPlugin but authelia.oidc.enable is false.";
            }
            {
              assertion = lib.all (r: !(r.oidcPlugin != null && r.oidcPlugin.enable && r.oidc == null)) (
                lib.attrValues effectiveRouters
              );
              message = "custom.web-expose: routers with oidcPlugin enabled must have an oidc client configured in Authelia.";
            }
            {
              assertion = lib.all (r: !(r.oidcPlugin != null && r.oidcPlugin.enable && r.auth != null)) (
                lib.attrValues effectiveRouters
              );
              message = "custom.web-expose: routers with oidcPlugin enabled must not set auth (the plugin handles authentication).";
            }
            {
              assertion = !anyOidcPlugin || cfg.traefikOidcPlugin.enable;
              message = "custom.web-expose: traefikOidcPlugin.enable must be true when a router uses oidcPlugin.";
            }
            {
              assertion = !cfg.traefikOidcPlugin.enable || cfg.traefikOidcPlugin.sessionSecretFile != null;
              message = "custom.web-expose: traefikOidcPlugin.sessionSecretFile is required when the plugin is enabled.";
            }
            {
              assertion = !cfg.lldap.bootstrap.enable || cfg.lldap.enable;
              message = "custom.web-expose: lldap.bootstrap.enable requires lldap.enable.";
            }
            {
              assertion = !cfg.authelia.enable || cfg.lldap.enable;
              message = "custom.web-expose: authelia requires lldap (set lldap.enable = true).";
            }
          ];
        }

        {
          networking.firewall.allowedTCPPorts = [
            80
            443
          ];

          services.traefik = {
            enable = true;
            environmentFiles =
              [
                cfg.traefikEnvFile
              ]
              ++ lib.optional (cfg.traefikOidcPlugin.enable) "/var/lib/traefik/oidc-plugin.env";

            staticConfigOptions =
              {
                entryPoints = {
                  web = {
                    address = ":80";
                    http.redirections.entryPoint = {
                      to = "websecure";
                      scheme = "https";
                    };
                  };
                  websecure = {
                    address = ":443";
                    http.middlewares = ["forwarded-proto"];
                  };
                };
                certificatesResolvers.letsencrypt.acme = {
                  email = cfg.email;
                  storage = "/var/lib/traefik/acme.json";
                  dnsChallenge = {
                    provider = cfg.dnsChallenge.provider;
                    resolvers = [
                      "1.1.1.1:53"
                      "8.8.8.8:53"
                    ];
                  };
                };
                ping = {};
              }
              // lib.optionalAttrs cfg.traefikOidcPlugin.enable {
                experimental.plugins.traefik-oidc-auth = {
                  moduleName = "github.com/sevensolutions/traefik-oidc-auth";
                  version = cfg.traefikOidcPlugin.version;
                };
              };

            dynamicConfigOptions.http = {
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

              middlewares =
                {
                  lan-only.ipAllowList.sourceRange = cfg.privateNetworkRanges;
                  public-ratelimit.rateLimit = {
                    average = 100;
                    burst = 100;
                  };
                  security-headers.headers = {
                    hostsProxyHeaders = ["X-Forwarded-Host"];
                    stsSeconds = cfg.hstsSeconds;
                    stsIncludeSubdomains = true;
                    stsPreload = cfg.hstsSeconds > 0;
                    forceSTSHeader = cfg.hstsSeconds > 0;
                    customFrameOptionsValue = "SAMEORIGIN";
                    browserXssFilter = true;
                    referrerPolicy = "same-origin";
                    permissionsPolicy = "camera=(), microphone=(), geolocation=(), payment=(), usb=(), vr=()";
                    customResponseHeaders = {
                      X-Content-Type-Options = "nosniff";
                      X-Download-Options = "noopen";
                      X-Robots-Tag = "none,noarchive,nosnippet,notranslate,noimageindex,";
                      Referrer-Policy = "no-referrer";
                      server = "";
                    };
                  };
                  forwarded-proto.headers.customRequestHeaders = {
                    "X-Forwarded-Proto" = "https";
                  };
                  public.chain.middlewares = [
                    "public-ratelimit"
                    "security-headers"
                  ];

                  authelia = {
                    forwardAuth = {
                      address = "http://127.0.0.1:9091/api/authz/forward-auth?authelia_url=https%3A%2F%2F${cfg.authelia.subdomain}.${cfg.domain}%2F";
                      trustForwardHeader = true;
                      authResponseHeaders = [
                        "Remote-User"
                        "Remote-Groups"
                        "Remote-Email"
                        "Remote-Name"
                      ];
                    };
                  };
                }
                // lib.optionalAttrs anyOidcPlugin (
                  lib.mapAttrs' (
                    name: r:
                      lib.nameValuePair "${name}-oidc-plugin" {
                        plugin.traefik-oidc-auth = {
                          Secret = "\${TRAEFIK_OIDC_SESSION_SECRET}";
                          Provider = {
                            Url = "https://${cfg.authelia.subdomain}.${cfg.domain}";
                            ClientId = r.oidcPlugin.clientId;
                            ClientSecret = "\${TRAEFIK_OIDC_CLIENT_SECRET_${
                              lib.replaceStrings ["-"] ["_"] (lib.toUpper name)
                            }}";
                          };
                          Scopes = r.oidcPlugin.scopes;
                          UsePkce = r.oidcPlugin.usePkce;
                        };
                      }
                  )
                  oidcPluginRouters
                );

              routers =
                (lib.mapAttrs (name: r: {
                    rule = r.traefikRule;
                    entryPoints = ["websecure"];
                    service = r.subdomain;
                    tls = {
                      certResolver = "letsencrypt";
                      options = "default";
                    };
                    middlewares = let
                      base =
                        if r.public
                        then ["public"]
                        else ["lan-only"];
                      authMw =
                        if r.oidcPlugin != null && r.oidcPlugin.enable
                        then ["${name}-oidc-plugin"]
                        else lib.optional (r.auth != null) "authelia";
                    in
                      base ++ authMw;
                  })
                  effectiveRouters)
                // lib.optionalAttrs cfg.authelia.enable {
                  authelia = {
                    rule = "Host(`${cfg.authelia.subdomain}.${cfg.domain}`)";
                    entryPoints = ["websecure"];
                    service = "authelia";
                    tls = {
                      certResolver = "letsencrypt";
                      options = "default";
                    };
                    middlewares = ["public"];
                  };
                }
                // lib.optionalAttrs cfg.lldap.enable {
                  lldap = {
                    rule = "Host(`${cfg.lldap.subdomain}.${cfg.domain}`)";
                    entryPoints = ["websecure"];
                    service = "lldap";
                    tls = {
                      certResolver = "letsencrypt";
                      options = "default";
                    };
                    middlewares = [
                      "lan-only"
                      "security-headers"
                    ];
                  };
                };

              services =
                (lib.mapAttrs (_: r: {
                    loadBalancer =
                      {
                        servers = [
                          {url = "http://${r.host}:${builtins.toString r.port}";}
                        ];
                      }
                      // lib.optionalAttrs r.healthCheck.enable {
                        healthCheck = {
                          path = r.healthCheck.path;
                          interval = r.healthCheck.interval;
                        };
                      };
                  })
                  effectiveRouters)
                // lib.optionalAttrs cfg.authelia.enable {
                  authelia.loadBalancer.servers = [
                    {url = "http://127.0.0.1:9091";}
                  ];
                }
                // lib.optionalAttrs cfg.lldap.enable {
                  lldap.loadBalancer.servers = [
                    {url = "http://127.0.0.1:17170";}
                  ];
                };
            };
          };

          systemd.services.traefik = lib.mkIf anyOidcPlugin {
            preStart = ''
              ${oidcPluginEnvGen}
            '';
          };
        }

        (lib.mkIf cfg.lldap.enable {
          services.lldap = {
            enable = true;
            settings = {
              ldap_base_dn = cfg.lldap.baseDn;
              ldap_user_dn = cfg.lldap.adminUsername;
              database_url = "sqlite:///var/lib/lldap/users.db?mode=rwc";
            };
            environment = {
              LLDAP_JWT_SECRET_FILE = cfg.lldap.jwtSecretFile;
              LLDAP_KEY_SEED_FILE = cfg.lldap.keySeedFile;
              LLDAP_LDAP_USER_PASS_FILE = cfg.lldap.adminPasswordFile;
            };
          };

          systemd.services.lldap-bootstrap = lib.mkIf cfg.lldap.bootstrap.enable {
            description = "Bootstrap LLDAP users and groups";
            after = ["lldap.service"];
            requires = ["lldap.service"];
            wantedBy = ["multi-user.target"];
            serviceConfig = {
              Type = "oneshot";
              RemainAfterExit = true;
              User = "lldap";
              Group = "lldap";
              ExecStart = lldapBootstrap;
            };
          };
        })

        (lib.mkIf (cfg.authelia.enable && cfg.authelia.sessionProvider == "valkey") {
          services.redis = {
            package = pkgs.valkey;
            servers.authelia = {
              enable = true;
              bind = "127.0.0.1";
              port = 6379;
            };
          };
        })

        (lib.mkIf cfg.authelia.enable {
          services.authelia.instances.main = {
            enable = true;

            secrets = {
              jwtSecretFile = cfg.authelia.secrets.jwtSecretFile;
              sessionSecretFile = cfg.authelia.secrets.sessionSecretFile;
              storageEncryptionKeyFile = cfg.authelia.secrets.storageEncryptionKeyFile;
            };

            environmentVariables =
              {
                AUTHELIA_AUTHENTICATION_BACKEND_LDAP_PASSWORD_FILE = cfg.lldap.adminPasswordFile;
              }
              // lib.optionalAttrs anyOidc {
                X_AUTHELIA_CONFIG = "/var/lib/authelia-main/oidc-overlay.json";
              };

            settings = {
              theme = "auto";

              server = {
                address = "tcp://127.0.0.1:9091";
                endpoints.authz.forward-auth.implementation = "ForwardAuth";
              };

              log.level = "info";
              telemetry.metrics.enabled = false;

              authentication_backend = {
                ldap = {
                  implementation = "lldap";
                  address = "ldap://127.0.0.1:3890";
                  base_dn = cfg.lldap.baseDn;
                  user = "CN=${cfg.lldap.adminUsername},OU=people,${cfg.lldap.baseDn}";
                };
                password_reset.disable = true;
                password_change.disable = true;
              };

              access_control = {
                default_policy = cfg.authelia.defaultPolicy;
                rules =
                  (lib.mapAttrsToList (_: r: {
                    domain = ["${r.subdomain}.${cfg.domain}"];
                    policy = "bypass";
                    networks = cfg.privateNetworkRanges;
                  }) (lib.filterAttrs (_: r: r.public && r.auth != null && r.auth != "bypass") effectiveRouters))
                  ++ (lib.concatMap (
                    r:
                      map (path: {
                        domain = ["${r.subdomain}.${cfg.domain}"];
                        policy = "bypass";
                        resources = [path];
                      })
                      r.bypassPaths
                  ) (lib.attrValues authRouters))
                  ++ (lib.mapAttrsToList (_: r: {
                      domain = ["${r.subdomain}.${cfg.domain}"];
                      policy = r.auth;
                      subject = r.subjects;
                      resources = r.resources;
                      networks = r.networks;
                      methods = r.methods;
                    })
                    authRouters);
              };

              session =
                {
                  name = "authelia_session";
                  same_site = "lax";
                  inactivity = "5m";
                  expiration = "1h";
                  remember_me = "1M";
                  cookies = [
                    {
                      domain = cfg.domain;
                      authelia_url = "https://${cfg.authelia.subdomain}.${cfg.domain}";
                      name = "authelia_session";
                    }
                  ];
                }
                // lib.optionalAttrs (cfg.authelia.sessionProvider == "valkey") {
                  redis.host = "127.0.0.1";
                  redis.port = 6379;
                };

              regulation = {
                max_retries = 3;
                find_time = "2m";
                ban_time = "5m";
              };

              storage.local.path = "/var/lib/authelia-main/db.sqlite3";
              notifier.filesystem.filename = "/var/lib/authelia-main/notification.txt";
              webauthn.enable_passkey_login = true;
            };
          };

          systemd.services.authelia-main = {
            serviceConfig = {
              StateDirectory = "authelia-main";
              StateDirectoryMode = "0750";
            };
            preStart = lib.mkIf anyOidc (
              pkgs.writeShellScript "authelia-oidc-setup" ''
                set -euo pipefail
                OUT="/var/lib/authelia-main/oidc-overlay.json"
                install -m 600 /dev/null "$OUT"
                CLIENTS=$(${pkgs.coreutils}/bin/cat ${oidcClientsTemplate})
                ${lib.concatMapStrings (
                  r: let
                    o = r.oidc;
                  in ''
                    HASH=$(${pkgs.coreutils}/bin/cat "${o.client_secret_hash_file}")
                    CLIENTS=$(echo "$CLIENTS" | ${pkgs.jq}/bin/jq \
                      --arg id "${o.client_id}" \
                      --arg hash "$HASH" \
                      'map(if .client_id == $id then . + {client_secret: $hash} else . end)')
                  ''
                ) (lib.attrValues oidcRouters)}
                ${pkgs.jq}/bin/jq -n \
                  --arg hmac "$(${pkgs.coreutils}/bin/cat ${cfg.authelia.oidc.hmacSecretFile})" \
                  --arg key "$(${pkgs.coreutils}/bin/cat ${cfg.authelia.oidc.jwksRsaKeyFile})" \
                  --argjson clients "$CLIENTS" \
                  '{
                    identity_providers: {
                      oidc: {
                        hmac_secret: $hmac,
                        jwks: [{ algorithm: "RS256", use: "sig", key: $key }],
                        lifespans: {
                          access_token: "1h",
                          authorize_code: "1m",
                          id_token: "1h",
                          refresh_token: "90m"
                        },
                        clients: $clients
                      }
                    }
                  }' > "$OUT"
              ''
            );
          };
        })
      ]
    );
  };
}
