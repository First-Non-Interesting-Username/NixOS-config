## Table of Contents

## Secrets Reference

| Key              | Used in               | Description                                    |
| ---------------- | --------------------- | ---------------------------------------------- |
| `sudo_password`  | `nixosModules.user`   | User password hash (use `mkpasswd -m sha-512`) |
| `factorio_token` | `nixosModules.gaming` | Factorio.com auth token for mod downloads      |
| `github_pat`     | `git.nix`             | GitHub Personal Access Token                   |
