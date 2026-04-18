## Table of Contents

- [Table of Contents](#table-of-contents)
- [Steps](#steps)
  - [1. Find a host that you want to base the new host on](#1-find-a-host-that-you-want-to-base-the-new-host-on)
  - [2. Copy the host you want to use](#2-copy-the-host-you-want-to-use)
  - [3. Adjust modules](#3-adjust-modules)
  - [4. Adjust special args](#4-adjust-special-args)
  - [5. Generate and adjust hardware config](#5-generate-and-adjust-hardware-config)
  - [6. Add the host to the docs](#6-add-the-host-to-the-docs)
  - [7. Generate the user ssh keys (optional)](#7-generate-the-user-ssh-keys-optional)
  - [8. Generate the host ssh keys (optional)](#8-generate-the-host-ssh-keys-optional)
- [You are done!](#you-are-done)

# Steps

## 1. Find a host that you want to base the new host on

The list of all hosts is avalible at [hosts.md](./hosts.md).

Select the one you want to base your host on.

The [template host](./hosts.md#template) is suggested in all cases.

---

## 2. Copy the host you want to use

Copy the host directory (in `./hosts`), rename it (you can find avalible names [here](./hosts.md#unused-namesnames-suggestions)) or came up with your own.

---

## 3. Adjust modules

Add, or remove modules.

Full list of modules is avalible [here](./module-list.md).

---

## 4. Adjust special args

You need to change the hostname at least, else you will get build errors.

The full list of special args and the docs for them can be found [here](./special-args.md).

---

## 5. Generate and adjust hardware config

Get the nixos-facter result (`sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json`) and put the generated file in the host root.

Adjust nixos-hardware modules in `/hosts/{host}/hardware.nix`. [This](https://github.com/NixOS/nixos-hardware?tab=readme-ov-file#list-of-profiles) is the full list of those modules.

Add disko config in `/hosts/{host}/disko.nix`. Visit [disko github](https://github.com/nix-community/disko) for more informations and help with configuration.

---

## 6. Add the host to the docs

Add the new host to [docs/hosts.md](./hosts.md):

1. Add the host to the table of contents
2. Add a new section with the host name containing:
   - Brief description of the host
   - Hardware specifications
   - Whether it can be used as a template
   - Origin of the host name (character reference)

You should also add that host to [the host matrix in the README](../README.md#hosts-matrix).

---

## 7. Generate the user ssh keys (optional)

Run:

```bash
ssh-keygen -t ed25519 -f ./id_ed25519 -N "" -C "your_ssh_key_description"
```

Add those keys to the secrets.yaml file with sops in a pattern established with previous user ssh keys.

## 8. Generate the host ssh keys (optional)

Run:

```bash
ssh-keygen -t ed25519 -f ./ssh_host_ed25519_key -N "" -C "your_ssh_key_description"
```

You SHOULD copy those keys and put them somewhere safe.

You should also add the public key to the `.sops.yaml` file.
[Secrets README](../secrets//README.md#adding-ssh-keys-to-sopsyaml) will explain that to you.

---

# You are done!
