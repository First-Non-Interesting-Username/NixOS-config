# Services

## nixosModules.secrets

- Sets up secrets management system with sops.
- Sets host SSH key as a default key for age, which is used for sops.

## nixosModules.ssh

Secrets: ssh_keys/private/${hostname}, ssh_keys/public/${hostname}

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories with sops.

## nixosModules.secretless-ssh

PERSONAL
DON'T USE ON PRODUCTION MACHINES

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts publically available SSH public and private keys to right directories (now with persist, so they work with impermanence) with sops.

## nixosModules.ssh-debug

- Opens SSH for everyone, with root login.

## nixosModules.ssh-server

- Sets up SSH server on port 6767 (Yes, this is a 67 joke).
- Sets fail2ban for SSH.

## nixosModules.update

- Installs Nh and sets up automatic cleaning.
- Sets up Nh flake to remote of my flake.
- Enables weekly store optimizes.
- Enables daily automatic updates.

## nixosModules.web-expose

This is an actual module, with options. By itself, it will do nothing, you must configure it.

This module was created with heavy assistance of AI. I had the final word in everything and I manually fixed few issues, but I'm absolutely sure there are more of them.

- Runs Traefik with Let's Encrypt DNS-01 certificates, HTTP→HTTPS redirect, and modern TLS defaults.
- Distinguishes public (internet-facing) and LAN-only services, applying IP allowlists, rate limits, and security headers automatically.
- Enforces authentication policies (bypass, one_factor, two_factor, deny) on a per-router basis with subjects, networks, and resource ACLs.
- Provides a lightweight LDAP directory for Authelia, with automatic user and group bootstrapping on first startup.
- Exposes Authelia as an OpenID Connect identity provider for native OIDC applications (e.g., Grafana, Portainer).
- Optionally uses traefik-oidc-auth to make Traefik itself an OIDC client, enabling SSO for legacy apps without native OIDC support.
- All credentials, tokens, and keys are passed via external files (sops-nix compatible) with enforced service-user ownership.

Docs of the module are available [here](./web-expose.md)
