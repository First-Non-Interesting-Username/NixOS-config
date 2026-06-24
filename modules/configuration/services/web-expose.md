# `web-expose` NixOS Module

Unified Traefik + Authelia + LLDAP web exposure for NixOS. Securely expose internal services to the internet or LAN with automatic HTTPS, authentication, and identity management.

---

## What It Does (Overview)

- **Reverse Proxy & TLS**: Runs Traefik with automatic Let's Encrypt DNS-01 certificates, HTTP→HTTPS redirection, and modern TLS defaults.
- **Authentication Gateway**: Integrates Authelia as a ForwardAuth middleware for per-router access policies (bypass, one_factor, two_factor, deny).
- **Identity Backend**: Runs LLDAP (Lightweight LDAP) as the user directory for Authelia, with automatic user/group bootstrapping.
- **OIDC Provider**: Exposes Authelia as an OpenID Connect provider for native OIDC applications (e.g., Grafana, Portainer).
- **OIDC Plugin (RP)**: Optionally uses `traefik-oidc-auth` to make Traefik itself an OIDC client, enabling SSO for applications without native OIDC support.
- **Network Segmentation**: Distinguishes public (internet-facing) and LAN-only routers, applying IP allowlists and middleware chains automatically.
- **Secret Hygiene**: All secrets are passed via external files (env files or sops secrets) — nothing sensitive is baked into the Nix store.

---

## Architecture

```
Internet / LAN
       │
       ▼
   Traefik (443)
   ├─ Public Middleware (rate limit + security headers)
   ├─ LAN-Only Middleware (IP allowlist)
   ├─ Authelia ForwardAuth (optional)
   └─ traefik-oidc-auth Plugin (optional)
       │
       ▼
   Upstream Services (127.0.0.1:*)

Authelia (9091) ──► LLDAP (3890/17170)
   │
   └── OIDC Provider (for native OIDC clients + plugin)
```

---

## Prerequisites

1. A publicly resolvable domain (`example.com`).
2. A DNS provider supported by Traefik ACME (e.g., DuckDNS, Cloudflare, Route53).
3. `sops-nix` or another secret manager to provision files to the expected paths with correct ownership.
4. For OIDC: ability to generate PBKDF2 hashes via `authelia crypto hash generate pbkdf2`.

---

## Module Options Reference

### `custom.web-expose`

| Option                                | Type            | Default             | Description                                                                                          |
| ------------------------------------- | --------------- | ------------------- | ---------------------------------------------------------------------------------------------------- |
| `enable`                              | bool            | `false`             | Enable the entire module.                                                                            |
| `domain`                              | string          | —                   | Base domain for all exposed services.                                                                |
| `email`                               | string          | —                   | Contact email for Let's Encrypt ACME registration.                                                   |
| `traefikEnvFile`                      | path            | —                   | Path to an environment file containing DNS provider tokens. Must be readable by the `traefik` user.  |
| `dnsChallenge.provider`               | string          | `"duckdns"`         | ACME DNS challenge provider.                                                                         |
| `privateNetworkRanges`                | list of strings | RFC1918 ranges      | IPs allowed by the `lan-only` middleware and Authelia access control bypass for public+auth routers. |
| `hstsSeconds`                         | int             | `2592000` (30 days) | HSTS max-age. Set to `0` to disable.                                                                 |
| `traefikOidcPlugin.enable`            | bool            | `false`             | Enable the `traefik-oidc-auth` plugin catalog.                                                       |
| `traefikOidcPlugin.version`           | string          | `"v0.18.0"`         | Plugin version from the Traefik plugin registry.                                                     |
| `traefikOidcPlugin.sessionSecretFile` | null or path    | `null`              | Path to a 32+ byte secret for plugin session encryption. Required if plugin is enabled.              |

### `custom.web-expose.authelia`

| Option                             | Type   | Default                      | Description                                         |
| ---------------------------------- | ------ | ---------------------------- | --------------------------------------------------- |
| `enable`                           | bool   | `true` if auth/OIDC needed   | Enable Authelia.                                    |
| `subdomain`                        | string | `"auth"`                     | Subdomain for the Authelia portal.                  |
| `defaultPolicy`                    | enum   | `"two_factor"`               | Default policy for public routers.                  |
| `sessionProvider`                  | enum   | `"valkey"`                   | Session backend (`memory` or `valkey`).             |
| `secrets.jwtSecretFile`            | path   | —                            | JWT signing secret. Owner: `authelia-main`.         |
| `secrets.sessionSecretFile`        | path   | —                            | Session encryption secret. Owner: `authelia-main`.  |
| `secrets.storageEncryptionKeyFile` | path   | —                            | Database encryption key. Owner: `authelia-main`.    |
| `oidc.enable`                      | bool   | `true` if OIDC clients exist | Enable Authelia as an OIDC Provider.                |
| `oidc.hmacSecretFile`              | path   | —                            | OIDC HMAC secret. Owner: `authelia-main`.           |
| `oidc.jwksRsaKeyFile`              | path   | —                            | OIDC RSA private key (PEM). Owner: `authelia-main`. |

### `custom.web-expose.lldap`

| Option                                | Type            | Default                    | Description                              |
| ------------------------------------- | --------------- | -------------------------- | ---------------------------------------- |
| `enable`                              | bool            | `true` if Authelia enabled | Enable LLDAP.                            |
| `subdomain`                           | string          | `"ldap"`                   | Subdomain for LLDAP web UI.              |
| `adminUsername`                       | string          | `"admin"`                  | LLDAP admin username.                    |
| `adminPasswordFile`                   | path            | —                          | Admin password file. Owner: `lldap`.     |
| `jwtSecretFile`                       | path            | —                          | JWT secret. Owner: `lldap`.              |
| `keySeedFile`                         | path            | —                          | Key seed. Owner: `lldap`.                |
| `baseDn`                              | string          | `"DC=example,DC=com"`      | LDAP base DN.                            |
| `bootstrap.enable`                    | bool            | `true` if users defined    | Bootstrap users/groups on first start.   |
| `bootstrap.groups.<name>.name`        | string          | attrset name               | Group name to create.                    |
| `bootstrap.users.<name>.id`           | string          | attrset name               | User login ID.                           |
| `bootstrap.users.<name>.email`        | string          | —                          | User email.                              |
| `bootstrap.users.<name>.passwordFile` | null or path    | `null`                     | Plaintext password file. Owner: `lldap`. |
| `bootstrap.users.<name>.displayName`  | null or string  | `null`                     | Display name.                            |
| `bootstrap.users.<name>.firstName`    | null or string  | `null`                     | First name.                              |
| `bootstrap.users.<name>.lastName`     | null or string  | `null`                     | Last name.                               |
| `bootstrap.users.<name>.groups`       | list of strings | `[]`                       | Groups to add the user to.               |

### `custom.web-expose.routers.<name>`

| Option                            | Type              | Default                        | Description                                                                                               |
| --------------------------------- | ----------------- | ------------------------------ | --------------------------------------------------------------------------------------------------------- |
| `subdomain`                       | string            | —                              | Subdomain for this service.                                                                               |
| `port`                            | port              | —                              | Local port of the upstream service.                                                                       |
| `host`                            | string            | `"127.0.0.1"`                  | Upstream host.                                                                                            |
| `public`                          | bool              | `false`                        | `true` = internet-facing; `false` = LAN-only.                                                             |
| `auth`                            | null or enum      | `null`                         | ForwardAuth policy: `bypass`, `one_factor`, `two_factor`, `deny`. Must be `null` if `oidcPlugin` is used. |
| `subjects`                        | list              | `[]`                           | Authelia ACL subjects (e.g., `user:alice`, `group:admins`).                                               |
| `resources`                       | list of strings   | `[]`                           | Authelia ACL resource patterns.                                                                           |
| `networks`                        | list of strings   | `[]`                           | Authelia ACL source networks.                                                                             |
| `methods`                         | list of strings   | `[]`                           | Authelia ACL HTTP methods.                                                                                |
| `traefikRule`                     | string            | `Host(\`sub.domain\`)`         | Custom Traefik router rule.                                                                               |
| `healthCheck.enable`              | bool              | `false`                        | Enable backend health checks.                                                                             |
| `healthCheck.path`                | string            | `"/"`                          | Health check path.                                                                                        |
| `healthCheck.interval`            | string            | `"10s"`                        | Health check interval.                                                                                    |
| `oidc`                            | null or submodule | `null`                         | Register an OIDC client in Authelia for native OIDC apps.                                                 |
| `oidc.client_id`                  | string            | router name                    | OIDC client ID.                                                                                           |
| `oidc.client_secret_hash_file`    | path              | —                              | PBKDF2 hash of the client secret. Owner: `authelia-main`.                                                 |
| `oidc.redirect_uris`              | list of strings   | —                              | Allowed redirect URIs. The plugin callback is auto-injected when `oidcPlugin` is used.                    |
| `oidc.scopes`                     | list              | `["openid" "profile" "email"]` | OIDC scopes.                                                                                              |
| `oidc.grant_types`                | list              | `["authorization_code"]`       | Grant types.                                                                                              |
| `oidc.response_types`             | list              | `["code"]`                     | Response types.                                                                                           |
| `oidc.token_endpoint_auth_method` | string            | `"client_secret_post"`         | Token endpoint auth method.                                                                               |
| `oidc.consent_mode`               | string            | `"auto"`                       | Consent mode.                                                                                             |
| `oidcPlugin`                      | null or submodule | `null`                         | Use `traefik-oidc-auth` plugin for non-native OIDC apps.                                                  |
| `oidcPlugin.enable`               | bool              | `false`                        | Enable the plugin for this router.                                                                        |
| `oidcPlugin.clientId`             | string            | `oidc.client_id` or name       | OIDC client ID (must match Authelia registration).                                                        |
| `oidcPlugin.clientSecretFile`     | path              | —                              | Plaintext client secret. Owner: `traefik`.                                                                |
| `oidcPlugin.scopes`               | list              | `["openid" "profile" "email"]` | Requested scopes.                                                                                         |
| `oidcPlugin.usePkce`              | bool              | `true`                         | Enable PKCE.                                                                                              |

---

## Secret Ownership Cheat Sheet

| Secret                                | Service User    | Reader                            |
| ------------------------------------- | --------------- | --------------------------------- |
| `traefikEnvFile` (DNS tokens)         | `traefik`       | Traefik daemon                    |
| `traefikOidcPlugin.sessionSecretFile` | `traefik`       | Traefik daemon + preStart script  |
| `oidcPlugin.clientSecretFile`         | `traefik`       | Traefik daemon + preStart script  |
| `lldap.adminPasswordFile`             | `lldap`         | LLDAP daemon + bootstrap service  |
| `lldap.jwtSecretFile`                 | `lldap`         | LLDAP daemon                      |
| `lldap.keySeedFile`                   | `lldap`         | LLDAP daemon                      |
| `lldap.bootstrap.*.passwordFile`      | `lldap`         | `lldap-bootstrap` service         |
| `authelia.secrets.*`                  | `authelia-main` | Authelia daemon                   |
| `authelia.oidc.hmacSecretFile`        | `authelia-main` | Authelia daemon + preStart script |
| `authelia.oidc.jwksRsaKeyFile`        | `authelia-main` | Authelia daemon + preStart script |
| `oidc.client_secret_hash_file`        | `authelia-main` | Authelia preStart script          |

**Rule of thumb**: set the sops secret `owner` to the exact service user. Never use `root` or world-readable modes unless you have no other choice.

---

## Setup Instructions

### 1. Generate Secrets

```bash
# Traefik DNS provider token
echo 'DUCKDNS_TOKEN=your-token-here' > ./secrets/traefik.env

# LLDAP secrets
openssl rand -hex 32 > ./secrets/lldap-jwt-secret
openssl rand -hex 32 > ./secrets/lldap-key-seed
openssl rand -hex 16 > ./secrets/lldap-admin-password

# Authelia core secrets
openssl rand -hex 32 > ./secrets/authelia-jwt-secret
openssl rand -hex 32 > ./secrets/authelia-session-secret
openssl rand -hex 32 > ./secrets/authelia-storage-encryption-key

# Authelia OIDC provider secrets
openssl rand -hex 64 > ./secrets/authelia-oidc-hmac-secret
openssl genrsa -out ./secrets/authelia-oidc-jwks.pem 4096

# Traefik OIDC plugin session secret (only if using plugin)
openssl rand -hex 32 > ./secrets/traefik-oidc-session-secret

# Per-client OIDC secrets (repeat for each router)
SECRET=$(openssl rand -hex 32)
echo "$SECRET" > ./secrets/myapp-oidc-plaintext
nix run nixpkgs#authelia -- crypto hash generate pbkdf2 --no-confirm --password "$SECRET" > ./secrets/myapp-oidc-hash
```

### 2. Add to SOPS / Secret Manager

Encrypt the files above and provision them to the target host. Example with `sops-nix`:

```nix
sops.secrets = {
  "traefik/env"              = { owner = "traefik"; };
  "traefik-oidc-session"     = { owner = "traefik"; };
  "lldap/admin-password"     = { owner = "lldap"; };
  "lldap/jwt-secret"       = { owner = "lldap"; };
  "lldap/key-seed"         = { owner = "lldap"; };
  "authelia/jwt-secret"      = { owner = "authelia-main"; };
  "authelia/session-secret"  = { owner = "authelia-main"; };
  "authelia/storage-key"     = { owner = "authelia-main"; };
  "authelia/oidc-hmac"       = { owner = "authelia-main"; };
  "authelia/oidc-jwks"       = { owner = "authelia-main"; };
  "myapp/oidc-plaintext"     = { owner = "traefik"; };
  "myapp/oidc-hash"          = { owner = "authelia-main"; };
  "users/alice-password"     = { owner = "lldap"; };
};
```

### 3. Minimal Configuration

```nix
{ config, ... }: {
  custom.web-expose = {
    enable = true;
    domain = "example.com";
    email = "admin@example.com";
    traefikEnvFile = config.sops.secrets."traefik/env".path;

    lldap = {
      adminPasswordFile = config.sops.secrets."lldap/admin-password".path;
      jwtSecretFile     = config.sops.secrets."lldap/jwt-secret".path;
      keySeedFile       = config.sops.secrets."lldap/key-seed".path;
    };

    authelia = {
      secrets = {
        jwtSecretFile           = config.sops.secrets."authelia/jwt-secret".path;
        sessionSecretFile       = config.sops.secrets."authelia/session-secret".path;
        storageEncryptionKeyFile = config.sops.secrets."authelia/storage-key".path;
      };
    };

    routers.whoami = {
      subdomain = "whoami";
      port = 8080;
      public = true;
    };
  };
}
```

### 4. LAN-Only Service with Auth

```nix
routers.sonarr = {
  subdomain = "sonarr";
  port = 8989;
  public = false;           # LAN-only IP allowlist
  auth = "two_factor";      # Authelia ForwardAuth
  subjects = [ "group:media" ];
};
```

### 5. Native OIDC Client (e.g., Grafana)

```nix
routers.grafana = {
  subdomain = "grafana";
  port = 3000;
  public = true;
  auth = "bypass";          # Grafana does its own OIDC login

  oidc = {
    client_secret_hash_file = config.sops.secrets."grafana/oidc-hash".path;
    redirect_uris = [ "https://grafana.example.com/login/generic_oauth" ];
    scopes = [ "openid" "profile" "email" "groups" ];
  };
};
```

### 6. Non-Native OIDC via Plugin (e.g., plain HTTP app)

```nix
routers.legacy = {
  subdomain = "legacy";
  port = 5000;
  public = true;
  auth = null;              # Plugin handles auth, not ForwardAuth

  oidc = {
    client_secret_hash_file = config.sops.secrets."legacy/oidc-hash".path;
    redirect_uris = [ ];      # /oauth2/callback injected automatically
  };

  oidcPlugin = {
    enable = true;
    clientSecretFile = config.sops.secrets."legacy/oidc-plaintext".path;
  };
};
```

### 7. Bootstrap LLDAP Users and Groups

```nix
lldap.bootstrap = {
  groups.admins = { name = "admins"; };
  groups.media  = { name = "media"; };

  users.alice = {
    email = "alice@example.com";
    passwordFile = config.sops.secrets."users/alice-password".path;
    displayName = "Alice";
    firstName = "Alice";
    lastName = "Smith";
    groups = [ "admins" ];
  };

  users.bob = {
    email = "bob@example.com";
    passwordFile = config.sops.secrets."users/bob-password".path;
    groups = [ "media" ];
  };
};
```

After deployment, the `lldap-bootstrap` systemd service runs once after `lldap.service` starts. To re-run after adding users:

```bash
sudo systemctl restart lldap-bootstrap
```

---

## Important Rules & Assertions

The module enforces these constraints at evaluation time:

1. **Authelia required for auth**: If any router sets `auth`, `authelia.enable` must be `true`.
2. **OIDC auth conflict**: A router with `oidc` cannot also have `auth` (unless `auth = "bypass"`).
3. **Plugin requires OIDC registration**: A router with `oidcPlugin.enable = true` must also have an `oidc` block so Authelia knows the client.
4. **Plugin disables ForwardAuth**: A router with `oidcPlugin` must not set `auth`.
5. **Plugin global enable**: If any router uses `oidcPlugin`, `traefikOidcPlugin.enable` must be `true`.
6. **Plugin session secret**: If the plugin is enabled, `traefikOidcPlugin.sessionSecretFile` is mandatory.
7. **LLDAP required**: `authelia.enable` requires `lldap.enable`.
8. **Bootstrap requires LLDAP**: `lldap.bootstrap.enable` requires `lldap.enable`.
9. **OIDC requires secrets**: If any router has `oidc`, `authelia.oidc.enable` must be `true` and the HMAC/JWKS secrets must be provided.

---

## Middleware Chain Reference

| Exposure                       | Middlewares Applied                                           |
| ------------------------------ | ------------------------------------------------------------- |
| `public = true`                | `public` (rate limit + security headers) + auth if configured |
| `public = true` + `oidcPlugin` | `public` + `${name}-oidc-plugin`                              |
| `public = false`               | `lan-only` (IP allowlist) + auth if configured                |
| Authelia portal                | `public`                                                      |
| LLDAP portal                   | `lan-only` + `security-headers`                               |

### Private Network Bypass

When a router has `public = true` and an auth policy set (e.g. `auth = "two_factor"`),
requests originating from `privateNetworkRanges` are automatically granted a `bypass`
policy in Authelia's access control — no authentication required. This is implemented
as prepended access control rules (first-match-wins) that match private IPs before the
normal per-router policies are evaluated. External traffic still goes through
authentication normally.

---

## Troubleshooting

| Problem                                        | Cause                                                    | Fix                                                                                        |
| ---------------------------------------------- | -------------------------------------------------------- | ------------------------------------------------------------------------------------------ |
| `lldap-bootstrap` fails with Permission denied | Secret owned by wrong user                               | Set `owner = "lldap"` on bootstrap password files                                          |
| `traefik-oidc-auth` plugin not found           | Plugin not enabled in static config                      | Set `traefikOidcPlugin.enable = true`                                                      |
| Authelia OIDC clients not configured           | Missing `authelia.oidc.enable` or secrets                | Enable OIDC and provide `hmacSecretFile` + `jwksRsaKeyFile`                                |
| Double login loop                              | Router has both `oidc` and `auth != null`                | Set `auth = null` or `"bypass"` for OIDC routers                                           |
| Plugin callback rejected                       | Redirect URI mismatch                                    | Ensure `oidc.redirect_uris` includes the app's callback, or leave empty for auto-injection |
| Traefik cannot read env file                   | Wrong ownership on `traefikEnvFile` or `oidc-plugin.env` | Set `owner = "traefik"`, mode `0400`                                                       |

---

## Files & Services

| File / Service                             | Purpose                                                  |
| ------------------------------------------ | -------------------------------------------------------- |
| `/var/lib/traefik/acme.json`               | Let's Encrypt certificate storage                        |
| `/var/lib/traefik/oidc-plugin.env`         | Runtime-generated env file with OIDC plugin secrets      |
| `/var/lib/authelia-main/oidc-overlay.json` | Runtime-generated Authelia OIDC client configuration     |
| `/var/lib/lldap/users.db`                  | LLDAP SQLite database                                    |
| `traefik.service`                          | Reverse proxy and TLS termination                        |
| `authelia-main.service`                    | Authentication and SSO server                            |
| `lldap.service`                            | LDAP directory server                                    |
| `lldap-bootstrap.service`                  | One-shot user/group provisioning                         |
| `redis-authelia.service`                   | Optional session store (if `sessionProvider = "valkey"`) |
