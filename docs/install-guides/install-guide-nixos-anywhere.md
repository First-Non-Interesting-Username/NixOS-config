<!--
SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username

SPDX-License-Identifier: GPL-3.0-or-later
-->

> [!CAUTION]
> **Outsider Warning**: Create an issue if you have any problems, this guide was written for me, outside installations are supported.
> **Data Loss Warning**: This process will wipe the target disk. Ensure you have backups.

> [!NOTE]
> This is a general guide for installing NixOS on a machine on your local network using `nixos-anywhere`.
> You can find the list of all guides in [this file](../install-guides.md).

## Table of Contents

- [Definitions](#definitions)
- [Prerequisites](#prerequisites)
- [Steps](#steps)
  - [1. Prepare the Target machine](#1-prepare-the-target-machine)
    - [1.1 Network connection](#11-network-connection)
    - [1.2 Get the IP address](#12-get-the-ip-address)
    - [1.3 Enable SSH and set root password](#13-enable-ssh-and-set-root-password)
  - [2. Prepare the host SSH keys (Source machine)](#2-prepare-the-host-ssh-keys-source-machine)
    - [2.1 Create the temporary directory](#21-create-the-temporary-directory)
    - [2.2 Copy or generate host keys](#22-copy-or-generate-host-keys)
    - [2.3 Set correct permissions](#23-set-correct-permissions)
  - [3. Install the system (Source machine)](#3-install-the-system-source-machine)
  - [4. Post Install](#4-post-install)

## Definitions

In this guide, the following terms are used:

- **Target**: The machine where you want to install NixOS.
- **Source**: The machine you are installing _from_ (must have Nix installed and access to this repository).

---

# Prerequisites

1.  **Target**: Booted into a Linux live ISO (preferably the one from this config's releases, [iso docs](../iso.md) for more informations).
2.  **Source**: A machine with Nix installed and network access to the Target.
3.  **Network**: Both machines must be on the same network.
4.  **SSH**: The Source must be able to SSH into the Target as `root`.
5.  **Host Configuration**: You must have a host already defined in `hosts/`. If not, see the [Host creation guide](../host-guide.md).

---

# Steps

## 1. Prepare the Target machine

All commands in this section MUST be executed on the **Target**.

### 1.1 Network connection

Ensure the Target is connected to the internet (via Ethernet or Wi-Fi). If using Wi-Fi on a desktop ISO, use the network manager applet or `nmtui`.

### 1.2 Get the IP address

Run:

```bash
ip addr show
```

Find the IP address on your local network (usually starts with `192.168.x.x`, `172.x.x.x`, or `10.x.x.x`). **Note this down.**

### 1.3 Enable SSH and set root password

If you are using the official NixOS ISO or a custom one without a root password set, you need to set one to allow `nixos-anywhere` to connect.

To set a temporary root password:

```bash
sudo passwd root
```

Ensure the SSH server is running:

```bash
sudo systemctl start sshd
```

---

## 2. Prepare the host SSH keys (Source machine)

This step is mandatory if your host uses secrets (SOPS). These keys allow the new installation to decrypt secrets immediately upon booting.

All commands in this section MUST be executed on the **Source**.

### 2.1 Create the temporary directory

Depending on whether your host uses **preservation** or not, the directory structure for extra files differs.

**For hosts WITHOUT preservation:**

```bash
mkdir -p ./tmp/etc/ssh
```

**For hosts WITH preservation:**

```bash
mkdir -p ./tmp/persist/etc/ssh
```

### 2.2 Copy or generate host keys

Copy your host's SSH private and public keys into the directory created above. The files MUST be named `ssh_host_ed25519_key` and `ssh_host_ed25519_key.pub`.

If you haven't generated them yet, see [Step 8 of the Host creation guide](../host-guide.md#8-generate-the-host-ssh-keys-optional).

### 2.3 Set correct permissions

**For hosts WITHOUT preservation:**

```bash
sudo chown -R root:root ./tmp/etc/ssh
sudo chmod 600 ./tmp/etc/ssh/ssh_host_ed25519_key
sudo chmod 644 ./tmp/etc/ssh/ssh_host_ed25519_key.pub
```

**For hosts WITH preservation:**

```bash
sudo chown -R root:root ./tmp/persist/etc/ssh
sudo chmod 600 ./tmp/persist/etc/ssh/ssh_host_ed25519_key
sudo chmod 644 ./tmp/persist/etc/ssh/ssh_host_ed25519_key.pub
```

---

## 3. Install the system (Source machine)

Run these commands from the root of this repository on the **Source** machine.

Replace `HOSTNAME` with your target host name and `IP` with the IP address noted in Step 1.2.

```bash
nix run github:nix-community/nixos-anywhere -- \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./tmp \
  --target-host "root@IP"
```

---

## 4. Post Install

After the machine reboots:

1. Review the `IMPERATIVE` section in `hosts/HOSTNAME/README.md`.
2. Apply any host-specific manual steps.

# You are done!
