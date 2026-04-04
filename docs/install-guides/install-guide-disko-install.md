> [!CAUTION]
> **Outsider Warning**: Create an issue if you have any problems, this guide was written for me, outside installations are supported.
> **Data Loss Warning**: This process will wipe the target disk. Ensure you have backups.

> [!NOTE]
> This is a general guide, for general purpose machines on your local network.
> You can find all guides in [this file](./install-guides.md).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [Get the SSH host keys](#1-get-the-ssh-host-keys)
    - [Generate the SSH keys](#11-generate-the-ssh-keys)
    - [Add the encryption keys to .sops.yaml](#12-add-the-encryption-keys-to-sopsyaml)
  - [Boot the ISO on the target machine](#2-boot-the-iso-on-the-target-machine)
    - [Elevate your permissions](#20-elevate-your-permissions)
    - [Open SSH](#21-open-ssh)
    - [Set the password](#22-set-the-password)
    - [Log in to wifi (If applicable)](#23-log-in-to-wifi-if-applicable)
  - [Prepare the environment](#3-prepare-the-environment)
    - [Assign correct ownership and permissions to the keys](#31-assign-correct-ownership-and-permissions-to-the-keys)
  - [Install the system](#4-install-the-system)
  - [Post Install](#5-post-install)

# Prerequisites

1. **NixOS live ISO**: Choose whatever ISO you want to use. I recommend the official ISO of this config. You can get it from releases.
2. **Internet Connection**: Ensure you have internet access.
3. **Secure Boot**: Disable Secure Boot in UEFI.
4. **Chosen host**: Choose one of the [hosts](./hosts.md). If you don't have a host chosen or prepared head to [Host creation guide](./host-guide.md). It is a bad idea to use a host not created specyfically for your hardware and usecase.

---

# Steps

## 1. Boot the ISO

I hope I don't have to explain how to boot live ISO.

If you have any problems with that please let me know in the issues.
It might be a bad idea to install this config if you don't know how to boot an ISO on your machine.

### 1.0 Elevate your permissions

Run:

```bash
sudo -i
```

### 1.1 Log in to wifi (If applicable)

Login to your home wifi, either with the desktop provided app, `nmtui` or whatever other method you prefe.

Then you need to get your hostname.

## 2. Prepare the ssh host keys

This step is needed only for machines utilizing secrets.

### 2.1 Copy over your host ssh public keys

Copy your host, both public and private ssh keys to the working direcotory.

The keys should follow standard naming scheme (`ssh_host_ed25519_key` for private key, `ssh_host_ed25519_key.pub` for public key)

### 2.2 Assing correct permissions and ownerships to the keys

Run:

```bash
chown root:root ./ssh_host_ed25519_key{,.pub} && chmod 600 ./ssh_host_ed25519_key && chmod 644 ./ssh_host_ed25519_key.pub
```

## 3. Install the system

`HOSTNAME` is the hostname of the host you choose.

No impermanence:

```bash
sudo nix --extra-experimental-features "nix-command flakes pipe-operators" \
  run github:nix-community/disko/latest#disko-install -- \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key \
  --extra-files ./ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub \
  --write-efi-boot-entries
```

With impermanence:

```bash
sudo nix --extra-experimental-features "nix-command flakes pipe-operators" \
  run github:nix-community/disko/latest#disko-install -- \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./ssh_host_ed25519_key /persist/etc/ssh/ssh_host_ed25519_key \
  --extra-files ./ssh_host_ed25519_key.pub /persist/etc/ssh/ssh_host_ed25519_key.pub \
  --write-efi-boot-entries
```

## 4. Post Install

Review the `IMPERATIVE` section of your host documentation and apply the steps from it.

# You are done!
