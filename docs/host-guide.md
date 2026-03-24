## Table of Contents

- [Steps](#steps)
  - [Find a host that you want to base the new host on](#1-find-a-host-that-you-want-to-base-the-new-host-on)
  - [Copy the host you want to use](#2-copy-the-host-you-want-to-use)
  - [Adjust modules](#3-adjust-modules)
  - [Adjust special args](#4-adjust-special-args)
  - [Generate the host ssh keys (optional)](#5-generate-the-host-ssh-keys-optional)

# Steps

## 1. Find a host that you want to base the new host on

The list of all hosts is avalible at [hosts.md](./hosts.md).

Select the one you want to base your host on.

---

## 2. Copy the host you want to use

Copy the host directory, rename it (you can find avalible names [here](./hosts.md#unused-namesnames-suggestions)) or came up with your own, while respecting the rules.

---

## 3. Adjust modules

Add, or remove modules.

Full list of modules is avalible [here](./module-list.md).

---

## 4. Adjust special args

You need to at least change the hostname.

The full list of special args and the docs for them can be found [here](./special-args.md).

---

## 5. Generate or adjust hardware config

TBD

---

## 6. Add the host to the docs

TBD

---

## 6. Generate the host ssh keys (optional)

Run:

```bash
ssh-keygen -t ed25519 -f ./ssh_host_ed25519_key -N "" -C "your_host_description"
```

You SHOULD copy those keys and put them somewhere safe.

You should also add them to the `.sops.yaml` file.
[Secrets README](../secrets//README.md) will explain that to you.

---

# You are done!
