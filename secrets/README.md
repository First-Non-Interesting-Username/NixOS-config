# Table of Contents

- [Table of Contents](#table-of-contents)
- [Secrets Reference Table](#secrets-reference-table)
- [Adding new secrets](#adding-new-secrets)
- [Adding new age keys to `.sops.yaml`](#adding-new-age-keys-to-sopsyaml)
- [Referencing secrets in modules](#referencing-secrets-in-modules)
  - [Referencing secrets in home manager modules](#referencing-secrets-in-home-manager-modules)

# Secrets Reference Table

| Key                  | Used in                           | Description                                            |
| -------------------- | --------------------------------- | ------------------------------------------------------ |
| `sudo_password`      | `nixosModules.user`               | User password hash (use `mkpasswd -m yescrypt`)        |
| `factorio_token`     | `nixosModules.gaming`             | Factorio.com auth token for downloading factorio (TBD) |
| `github_pat`         | `nixosModules.git`                | GitHub Personal Access Token                           |
| `ssh_keys/public/*`  | `nixosModules.ssh`                | SSH public keys for hosts                              |
| `ssh_keys/private/*` | `nixosModules.ssh`                | SSH private keys for hosts                             |
| `LLM_keys/*`         | `nixosModules.opencode`           | LLM api keys for \*                                    |
| `wifi_password`      | `nixosModules.networking-desktop` | MY PERSONAL wifi password                              |

There are also a few secrets related to NPS. The NPS module is for private use, so this README does not document them in detail.

The `host_keys/*` secrets store my SSH host keys. I find it convenient to keep them in the secrets file.

# Adding new secrets

Edit `secrets/secrets.yaml` with `sops secrets/secrets.yaml`, add the unencrypted key-value pair, and save. SOPS will auto-encrypt the value.

# Adding new age keys to `.sops.yaml`

Add the public host key to the `keys` section in `.sops.yaml`, then re-save the secrets file to re-encrypt it for the new key.

When adding new age keys to `.sops.yaml`, you must re-save the secrets file so it's re-encrypted for the new key.

# Referencing secrets in modules

Use `config.sops.secrets.<name>.path` to reference secrets in NixOS module configuration.

You must activate the secret to use it, do that by adding `sops.secrets.<name> = {};`

## Referencing secrets in home manager modules

Use `osConfig.sops.secrets.<name>.path` to reference secrets in home-manager configuration.

Your user needs to have the access to that secret. add `owner = username` to `{}` in secret activation.
Remember to pass `username` to the module you are declaring the secret in.
