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
  - **Note**: This configuration utilizes a tiling Window Manager extension (Forge). If you're not familiar with tiling WMs, you might want to check the [keybinds](../desktop-environment/keybinds.md).
- **[Wall-E (CLI)](hosts.md#wall-e)**: This is a minimal, terminal-only version. It's ideal for systems with limited resources, servers, or older hardware that doesn't support modern graphical standards like Vulkan.
  - **Note**: This ISO is not available for download due to technical limitations. You must build it yourself using the instructions in the [Usage](#usage) section.

## Usage

### Downloading

You can download the latest version of the John (Graphical) ISO from the [Releases](https://github.com/First-Non-Interesting-Username/NixOS-config/releases) page of this repository.

**Note:** Only the most recent release is maintained for download. Older versions are removed to save space and ensure users are using the latest configuration.

### Building manually

If you want to use the Wall-E (CLI) ISO, or if you want to build the John ISO yourself, you can do so using the following command (requires Nix with flakes enabled):

```bash
# Build Wall-E (CLI) ISO
nix build github:First-Non-Interesting-Username/NixOS-config#wall-e

# Build John (Graphical) ISO
nix build github:First-Non-Interesting-Username/NixOS-config#john
```

The resulting ISO will be located in the `result/iso/` directory.

### Booting

If you still want to use the ISO and potentially install the system, here is a [Great ISO-to-booted system guide](https://techietory.com/os/how-to-create-bootable-linux-usb-drive/)
