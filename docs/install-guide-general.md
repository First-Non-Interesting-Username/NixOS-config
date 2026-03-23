> [!CAUTION]
> **Outsider Warning**: This process assumes you're me, but all kinds of installations are supported. Proceed with caution. Create an issue if you have any problems.
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

1. **Linux live ISO**: Choose whatever ISO you want to use. I recommend the official ISO of this config, from releases.
2. **Internet Connection**: Ensure you have internet access on both machines.
3. **Secure Boot**: Disable Secure Boot in UEFI.
4. **Chosen host**: Choose one of the hosts from [hosts](./hosts.md). If you don't have a host chosen or prepared head to [Host creation guide](./host-guide.md).
5. **Second PC with Nix installed**: It needs to be a different physical machine, this guide doesn't support other installers than [nixos-anywhere](https://github.com/nix-community/nixos-anywhere).
6. **SSH access**: You need SSH access from the second PC to the host. Most live ISOs include the SSH server.

From this point I will refer to the machine you are installing to as `Target` and the machine you are installing from as `Source`.

---

> [!NOTE]
> You technically don't have to work in the repo if you already have your age key in `.sops.yaml` or you use secretless host.
> To clone it, run `git clone https://github.com/First-Non-Interesting-Username/NixOS-config.git` or `gh repo clone First-Non-Interesting-Username/NixOS-config`.

---

# Steps

## 1. Get the SSH host keys

### 1.1 Generate the SSH keys

Run that in:

- `./tmp/etc/ssh` for setups without impermanence.
- `./tmp-persist/persist/etc/ssh` for setups without impermanence.

on source machine.

The part after `-C` is unnecessary, it's only for you to easier differentiate your keys.

```bash
ssh-keygen -t ed25519 -f ./ssh_host_ed25519_key -N "" -C "your_host_description"
```

You SHOULD copy those keys and put them somewhere safe.

### 1.2 Add the encryption keys to .sops.yaml

Omit this step if you use secret-less host.

Run:

```bash
nix --extra-experimental-features 'nix-command flakes' shell nixpkgs#ssh-to-age --command sh -c 'cat ./ssh_host_ed25519_key.pub | ssh-to-age'
```

and add the output of this command to `.sops.yaml` in the `keys` section with a name.
Add that name to `creation_rules/key_groups/age`.
Then (assuming you have access to a key previously existing in `.sops.yaml` on the source machine) run

```bash
sops updatekeys secrets/secrets.yaml
```

in the root of this flake.

---

## 2. Boot the ISO on the target machine

In this section, all commands MUST be executed on the target.

### 2.0 Elevate your permissions

Run:

```bash
sudo -i
```

### 2.1 Open SSH

Edit the SSH config:

```bash
sudo nano /etc/ssh/sshd_config
```

Find and set these lines (add them if they don't exist):

```
PasswordAuthentication yes
PermitRootLogin yes
```

(You don't have to use the root user, any user that can execute commands as root will be fine.
This guide assumes you will use the root user.)

Restart the SSH service:

```bash
sudo systemctl restart sshd
```

### 2.2 Set the password

Run:

```bash
passwd
```

and select new password.

Chosen password SHOULD be easy.
You MUST remember it.

### 2.3 Log in to wifi (If applicable)

Login to your home wifi, either with the desktop provided app or `nmtui`.

Then you need to get your hostname.

Run:

```bash
hostname -i
```

and find an IP address starting either with `192.168.`, `172.` or `10.`.

You MUST remember this IP address.

## 3. Prepare the environment

### 3.1 Assign correct ownership and permissions to the keys

Run:

```bash
chown root:root ./tmp/etc/ssh/ssh_host_ed25519_key{,.pub} && chmod 600 ./tmp/etc/ssh/ssh_host_ed25519_key && chmod 644 ./tmp/etc/ssh/ssh_host_ed25519_key.pub
```

No impermanence

```bash
chown root:root ./tmp-persist/persist/etc/ssh/ssh_host_ed25519_key{,.pub} && chmod 600 ./tmp-persist/persist/etc/ssh/ssh_host_ed25519_key && chmod 644 ./tmp-persist/persist/etc/ssh/ssh_host_ed25519_key.pub
```

With impermanence

## 4. Install the system

`HOSTNAME` is the hostname of the host you choose.
`IP` is the IP of the target.

No impermanence:

```bash
nix --extra-experimental-features "nix-command flakes pipe-operators" shell github:nix-community/nixos-anywhere --command nixos-anywhere \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./tmp \
  --target-host "root@IP"
```

With impermanence:

```bash
nix --extra-experimental-features "nix-command flakes pipe-operators" shell github:nix-community/nixos-anywhere --command nixos-anywhere \
  --flake "github:First-Non-Interesting-Username/NixOS-config#HOSTNAME" \
  --extra-files ./tmp \
  --target-host "root@IP"
```

## 5. Post Install

Review the `IMPERATIVE` section of your host documentation and apply the steps from it.

# You are done!
