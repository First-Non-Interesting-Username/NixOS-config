My config Install Guide

> # NOT WORKING FOR NOW, PLEASE DON'T USE, UNLESS YOU ACTIVELY WANT TO DESTROY YOUR SYSTEM

This guide will take you from fresh machine to complete setup, using parts of my NixOS configuration.

> [!CAUTION]
> **Outsider Warning**: This process assumes you're me, but all kinds of installations are supported. Proceed with caution. Create an issue if you have any problems
> **Data Loss Warning**: This process will wipe the target disk. Ensure you have backups.

## Prerequisites

1. **NixOS ISO**: Choose whatever ISO you want. Note that minimal ISO doesn't have ZFS support OOTB. (TBD) This guide assumes you use the ISO created from this config (`nix build .#minimal-iso`)
2. **Internet Connection**: Ensure you have internet access
3. **Secure Boot**: Disable Secure Boot in UEFI
4. **SSH keys**: Generate SSH keys on another machine (`ssh-keygen -t ed25519 -f /path/to/key -N ""`)
5. **Host configuration**: You will need a new host for your config. The creation of hosts is described in TBD

## 0. Obtain prequisites

### 0.1 Generate the SSH keys

Run that in any directory (preferably something empty).

The part after `-C` is unnecessary, it's only for you to easier differentiate your keys.

```bash
ssh-keygen -t ed25519 -f ./ssh_host_ed25519_key -N "" -C "your_host_description"
```

### 0.2 Add the encryption keys to .sops.yaml

Run:

```bash
nix-shell -p ssh-to-age --run 'cat ./ssh_host_ed25519_key.pub | ssh-to-age'
```

and add the output of this command to `.sops.yaml.`
Then (assuming you have access to a key previously existing in `.sops.yaml`) run

```bash
sops updatekeys secrets/secrets.yaml
```

in the root of this flake.

# Now you have to boot into the live ISO

## 1. Prepare the Environment

### 1.1 Increase your permissions

Elevate onto a root shell for the installation process:

```bash
sudo -i
```

### 1.2 Install required packages (This step will be deleted after creating custom install ISO)

We need git to clone the config and TBD

```bash
nix-env -iA nixos.git
```

### 1.3 Clone the config

You will need the config to acctually install the system (duh).

```bash
# Change to your repo if needed
git clone https://github.com/First-Non-Interesting-Username/NixOS-config
cd NixOS-config
```

### 1.4 Move the SSH keys to /etc/ssh

Copy the SSH keys (both private and public) generated in step `0.2` to `/etc/ssh`.

### 1.5 Correct the permissions of the SSH keys

The private key must have 600 permission, and the public key must have 644.

```bash
chmod 600 /etc/ssh/ssh_host_ed25519_key
chmod 644 /etc/ssh/ssh_host_ed25519_key.pub
```

#### 1.6 (TEMPORARY) Generate Networking Host ID

ZFS requires a unique `networking.hostId`. The default is "00000000", but it is best practice to set a unique one.

Generate it with:

```bash
head -c 4 /dev/urandom | od -A none -t x4
```

and put in `modules/hardware/yourhost/hardware.nix`, in the `networking.hostId` line.

## 2. Install the system

### 2a.1 Run the installation script

Just run:

```bash
./install.sh <your_hostname>
```

It might be necesarry to make the script executable. In that case run

```bash
chmod +x install.sh
```

### 2b.1 Copy the flake to temporary directory

Use whatever path you want (You will need to reuse this path).
Make sure there is nothing in the `/whatever/path/` directory

```bash
cp -r . /whatever/path/etc/nixos
```

### 2b.3 Create hardware config

Replance HOSTNAME with your actual hostname

```bash
nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o ./modules/hardware/HOSTNAME/facter.json
```

### 2b.3 Add the facter report to git

You will again have to replace HOSTNAME with your actual hostname.

```bash
git add ./modules/hardware/HOSTNAME/facter.json
```

### 2b.4 Install the system

HOSTNAME is your hostname, /whatever/path/etc/nixos is the same path as above.

```bash
nix shell github:nix-community/nixos-anywhere --command nixos-anywhere \
  --flake ".#HOSTNAME" \
  --copy-host-keys \
  --extra-files "/whatever/path" \
  --target-host "root@localhost"
```

## 3. Post-Install

TBD

# You're done!
