# Official ISO

## Table of Contents

- [General informations](#general-informations)
  - [Known limitations](#known-limitations)
- [Graphical vs. CLI](#graphical-vs-cli)
- [Usage](#usage)

## General informations

There are currently 2 ISOs included in the config: [wall-e](hosts.md#wall-e) and [john](hosts.md#john).

Both of them have the same username (`nixos`), user password (`nixos`) and root password (also `nixos`).

### Known limitations

Both of ISOs are x86_64 arch only, so they won't work on AArch64, ARM, RISC-V, legacy x86 machines or anything else.

I don't know if the ISOs work on PCs with NVIDIA GPUs, because I don't have any of those.

UEFI is required too.

## Graphical vs. CLI

The main difference between the two ISOs is the environment they provide:

- **[John (Graphical)](hosts.md#john)**: This version includes a full GNOME desktop environment. It's the recommended choice for most users, providing a more intuitive interface and including graphical tools like a web browser for easier troubleshooting or manual configuration. It requires a system that supports Vulkan.
- **[Wall-E (CLI)](hosts.md#wall-e)**: This is a minimal, terminal-only version. It's ideal for systems with limited resources, servers, or older hardware that doesn't support modern graphical standards like Vulkan. It's faster to download and boot but requires more familiarity with the command line.

## Usage

Download your selected ISO from the releases of this repo.

WIP

If you don't know what you're doing, please don't use my config and instead install some other distro.

If you still want to use the ISO and potentially install the system, here is a [Great ISO-to-booted system guide](https://techietory.com/os/how-to-create-bootable-linux-usb-drive/)
