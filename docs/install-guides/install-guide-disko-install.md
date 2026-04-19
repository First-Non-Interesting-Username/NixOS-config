> [!CAUTION]
> **Outsider Warning**: Create an issue if you have any problems, this guide was written for me, outside installations are supported.
> **Data Loss Warning**: This process will wipe the target disk. Ensure you have backups.

> [!NOTE]
> This guide is for a single-machine installation where you boot the target machine from a live ISO and perform the installation directly on it.
> You can find the list of all guides in [this file](../install-guides.md).

> [!WARNING]
> BROKEN FOR NOW, DON'T USE

## Table of Contents

- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [1. Boot and Prepare](#1-boot-and-prepare)
  - [2. Prepare Host SSH Keys](#2-prepare-host-ssh-keys)
  - [3. Run the Installation](#3-run-the-installation)
    - [For hosts WITHOUT impermanence](#for-hosts-without-impermanence)
    - [For hosts WITH impermanence](#for-hosts-with-impermanence)
  - [4. Post Install](#4-post-install)

# Prerequisites

1. **NixOS Live ISO**: I recommend using the official ISO from this config's releases, [iso docs](../iso.md) for more informations.
2. **Internet Connection**: Ethernet or Wi-Fi access.
3. **Secure Boot**: Must be disabled in UEFI.
4. **Host Configuration**: A host defined in `hosts/`. See [Host creation guide](../host-guide.md).

---

# Steps

## 1. Boot and Prepare

1. Boot the target machine from the live ISO.
2. Open a terminal.
3. Elevate to root:
   ```bash
   sudo -i
   ```
4. Connect to Wi-Fi if necessary (using `nmtui` or the desktop applet).

## 2. Prepare Host SSH Keys

This step is mandatory if your host uses secrets (SOPS).

1. Copy your host's SSH keys (`ssh_host_ed25519_key` and `ssh_host_ed25519_key.pub`) to the current directory on the live system.
2. Set correct permissions:
   ```bash
   chown root:root ./ssh_host_ed25519_key*
   chmod 600 ./ssh_host_ed25519_key
   chmod 644 ./ssh_host_ed25519_key.pub
   ```

## 3. Run the Installation

Replace `HOSTNAME` with your chosen host from the `hosts/` directory.

### For hosts WITHOUT impermanence

```bash
nix run github:nix-community/disko/latest#disko-install -- \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./ssh_host_ed25519_key /etc/ssh/ssh_host_ed25519_key \
  --extra-files ./ssh_host_ed25519_key.pub /etc/ssh/ssh_host_ed25519_key.pub \
  --write-efi-boot-entries
```

### For hosts WITH impermanence

```bash
nix run github:nix-community/disko/latest#disko-install -- \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./ssh_host_ed25519_key /persist/etc/ssh/ssh_host_ed25519_key \
  --extra-files ./ssh_host_ed25519_key.pub /persist/etc/ssh/ssh_host_ed25519_key.pub \
  --write-efi-boot-entries
```

## 4. Post Install

After the machine reboots:

1. Review the `IMPERATIVE` section in `hosts/HOSTNAME/README.md`.
2. Apply any host-specific manual steps.

# You are done!
