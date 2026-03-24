## Table of Contents

## Secrets Reference

| Key                  | Used in               | Description                                            |
| -------------------- | --------------------- | ------------------------------------------------------ |
| `sudo_password`      | `nixosModules.user`   | User password hash (use `mkpasswd -m sha-512`)         |
| `factorio_token`     | `nixosModules.gaming` | Factorio.com auth token for downloading factorio (TBD) |
| `github_pat`         | `nixosModules.git`    | GitHub Personal Access Token                           |
| `ssh_keys/public/*`  | `nixosModules.ssh`    | SSH public keys for hosts                              |
| `ssh_keys/private/*` | `nixosModules.ssh`    | SSH private keys for hosts                             |
