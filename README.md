# NixOS Config

> [!NOTE]
> This is a learning project in the first place.
> Please point out any issues you encounter. I will be more than happy to fix them and learn on my mistakes.

## Table of Contents

- [NixOS Config](#nixos-config)
- [Hosts Matrix](#hosts-matrix)
- [Docs](#docs)
  - [Modules](#modules)
  - [Installation Guides](#installation-guides)
  - [Host creation guide](#host-creation-guide)
  - [Secrets](#secrets)
- [Eye candy stuff](#eye-candy-stuff)
  - [Star History Chart](#star-history-chart)
  - [Screenshots](#screenshots)
- [Footnote](#footnote)
  - [Inspired by](#inspired-by)

## Hosts Matrix

| Hostname                         | Motherboard / Laptop Model | CPU         | GPU     | RAM  | Primary Purpose      |
| -------------------------------- | -------------------------- | ----------- | ------- | ---- | -------------------- |
| [armin](./hosts/armin/README.md) | Thinkpad L14 G4            | Ryzen 7330U | Vega 7  | 32GB | Desktop (Plasma)     |
| Minimal                          | N/A                        | N/A         | N/A     | N/A  | Other                |
| [iroh](./hosts/iroh/README.md)   | Optiplex 3060 Micro        | i5 8500T 4c | UHD 630 | 24GB | Local Server in a VM |
| Template                         | N/A                        | N/A         | N/A     | N/A  | Other                |

For more in depth explanation, visit [hosts](./docs/hosts.md).

## Docs

### Modules

- [Applications](./modules/applications/README.md)
- [Desktop](./modules/desktop/README.md)
- [Development](./modules/development/README.md)
- [Home](./modules/home/README.md)
- [Services](./modules/services/README.md)
- [System](./modules/system/README.md)
- [User](./modules/user/README.md)

### Installation Guides

Go to the [installation guides overview](./docs/install-guides.md) to select the guide that fits your situation best.

Remember to choose a host before installing.

### Host creation guide

Host creation guide is avalible [here](./docs/host-guide.md)

### Secrets

TBD

## Eye candy stuff

### Star History Chart

<a href="https://www.star-history.com/?repos=First-Non-Interesting-Username%2FNixOS-config&type=date&legend=top-left">
 <picture>
   <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/image?repos=First-Non-Interesting-Username/NixOS-config&type=date&theme=dark&legend=top-left" />
   <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/image?repos=First-Non-Interesting-Username/NixOS-config&type=date&legend=top-left" />
   <img alt="Star History Chart" src="https://api.star-history.com/image?repos=First-Non-Interesting-Username/NixOS-config&type=date&legend=top-left" />
 </picture>
</a>

### Screenshots

TBD

## Footnote

### Inspired by:

- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) — Helped me a lot in the later stages of the project. Golden standard for NixOS configs.
- [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config) — Great docs and unique way of enabling modules. Very interesting config.
