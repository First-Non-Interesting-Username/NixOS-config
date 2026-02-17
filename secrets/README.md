> This file was AI generated
> It is the only file in the entire repo that wasn't written by humans

# Secrets Setup Guide

This directory uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption.

## Quick Start (On Target System)

### 1. Get Your Age Public Key

The key should be derived from the **private** SSH host key, not the public key:

```bash
# Convert SSH host private key to age public key
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | tail -1
```

Or if you already have an age key in the sops-nix location:

```bash
sudo cat /var/lib/sops-nix/key.txt | grep "public key"
```

> **Note**: `ssh-to-age` reads the **private** key file to derive the age key pair.
> The age public key is used for encryption, and age derives the private key
> from the SSH private key at decryption time.

### 2. Update `.sops.yaml`

Edit `/.sops.yaml` in the repo root and replace the placeholder with your age public key:

```yaml
keys:
  - &desktop age1your_actual_public_key_here...
```

### 3. Encrypt the Secrets File

```bash
cd ~/Projects/NixOS-config

# Edit and encrypt (opens in $EDITOR, encrypts on save)
sops secrets/secrets.yaml

# OR encrypt in-place if you've already edited the plaintext:
sops --encrypt --in-place secrets/secrets.yaml
```

### 4. Editing Encrypted Secrets

After encryption, use sops to edit:

```bash
sops secrets/secrets.yaml
```

## Secrets Reference

| Key | Used By | Description |
| --- | ------- | ----------- |

| `sudo_password` | `user.nix` | User password hash (use `mkpasswd -m sha-512`) |
| `factorio_token` | `gaming.nix` | Factorio.com auth token for mod downloads |
| `github_pat` | `git.nix` | GitHub Personal Access Token |

## Generating Required Values

### Sudo Password Hash

```bash
mkpasswd -m sha-512
# Enter your password when prompted
# Copy the entire output starting with $6$...
```

### Factorio Token

1. Log into [factorio.com](https://factorio.com)
2. Go to Profile → Player data
3. Copy your token

### GitHub PAT

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Generate new token with needed scopes

## Troubleshooting

### "No key file found"

The age key file doesn't exist yet. Either:

- Run `nixos-rebuild` once (sops-nix will generate it with `age.generateKey = true`)
- Or manually create it:
  ```bash
  sudo mkdir -p /var/lib/sops-nix
  sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | sudo tee /var/lib/sops-nix/key.txt
  ```

### "Failed to decrypt"

The age key on the system doesn't match the one in `.sops.yaml`. Verify:

```bash
# Get the public key from current system
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | tail -1

# Compare with what's in .sops.yaml
```
