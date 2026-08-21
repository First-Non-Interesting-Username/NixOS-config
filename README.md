# NixOS Config

A comprehensive OS-as-a-code solution based on NixOS (Work in progress).

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/First-Non-Interesting-Username/NixOS-config)

> [!NOTE]
> This is a learning project in the first place.
> Please point out any issues you encounter. I will be more than happy to fix them and learn on my mistakes.

## Table of Contents

- [Hosts Matrix](#hosts-matrix)
- [Docs](#docs)
  - [Modules](#modules)
  - [Packages](#packages)
  - [Installation Guides](#installation-guides)
  - [Host creation guide](#host-creation-guide)
  - [Secrets](#secrets)
- [Eye candy stuff](#eye-candy-stuff)
  - [Star History Chart](#star-history-chart)
  - [Screenshots](#screenshots)
- [Footnote](#footnote)
  - [Inspired by](#inspired-by)

## Hosts Matrix

| Hostname                               | Motherboard / Laptop Model | CPU         | GPU               | RAM  | Primary Purpose  |
| -------------------------------------- | -------------------------- | ----------- | ----------------- | ---- | ---------------- |
| [armin](./hosts/armin/README.md)       | Framework 13               | Ryzen 7640U | Radeon 760M       | 16GB | Desktop (GNOME)  |
| [john](./hosts/john/README.md)         | N/A                        | N/A         | N/A               | N/A  | Installation ISO |
| [wall-e](./hosts/wall-e/README.md)     | N/A                        | N/A         | N/A               | N/A  | Installation ISO |
| [template](./hosts/template/README.md) | N/A                        | N/A         | N/A               | N/A  | Other            |
| [victim](./hosts/victim/README.md)     | Gigabyte Eagle B650 AX     | Ryzen 7500F | Radeon RX 7800 XT | 32GB | Desktop (GNOME)  |

## Quickstart

To use modules or packages from this flake in your own configuration, add it as an input:

```nix
inputs.nixos-config.url = "github:First-Non-Interesting-Username/NixOS-config";
```

Then, include the desired modules in your `nixosSystem`:

```nix
modules = [
  inputs.nixos-config.nixosModules.audio
  # See module docs for configuration options
];
```

For detailed instructions on internal and external usage, see the [Usage Guide](./docs/usage.md).

## Footnote

### Inspired by:

- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) — Helped me a lot in the later stages of the project. Golden standard for NixOS configs.
- [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config) — Great docs and unique way of enabling modules. Very interesting config.
- [Tarow/nix-podman-stacks](https://github.com/Tarow/nix-podman-stacks) - Extremely helpful for setting up my own homelab. Highly recommended.

### License

This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
