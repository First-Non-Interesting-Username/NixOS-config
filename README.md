# NixOS Config

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

| Hostname                               | Motherboard / Laptop Model | CPU         | GPU     | RAM  | Primary Purpose      |
| -------------------------------------- | -------------------------- | ----------- | ------- | ---- | -------------------- |
| [armin](./hosts/armin/README.md)       | Thinkpad L14 G4            | Ryzen 7330U | Vega 7  | 32GB | Desktop (Plasma)     |
| [john](./hosts/john/README.md)         | N/A                        | N/A         | N/A     | N/A  | Installation ISO     |
| [wall-e](./hosts/wall-e/README.md)     | N/A                        | N/A         | N/A     | N/A  | Installation ISO     |
| [iroh](./hosts/iroh/README.md)         | Optiplex 3060 Micro        | i5 8500T 4c | UHD 630 | 24GB | Local Server in a VM |
| [template](./hosts/template/README.md) | N/A                        | N/A         | N/A     | N/A  | Other                |

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

For the full list, go [here](./docs/module-list.md).

If you want to use those modules outside this flake, go to TBD.

### Packages

For the list of the packages go [here](./docs/package-list.md).

If you want to use those packages outside this flake, go to TBD.

### Installation Guides

Go to the [installation guides overview](./docs/install-guides.md) to select the guide that fits your situation best.

Remember to choose a host before installing.

### Host creation guide

Host creation guide is avalible [here](./docs/host-guide.md)

### Secrets

Go [here](./secrets/README.md).

Be aware that you need to add your own keys and replace the secrets with yours.
This is not a trivial task, I recommend using secretless modules.

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

Armin:
<img width="1920" height="1080" alt="Screenshot from GNOME desktop" src="https://github.com/user-attachments/assets/28443716-6298-4538-929d-ccd03d0ed6a4" />

Iroh:
<img width="1332" height="927" alt="Screenshot of a NoVNC console " src="https://github.com/user-attachments/assets/ee8d8d41-70ba-48e2-b30a-a3792e2ebfd3" />

## Footnote

### Inspired by:

- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) — Helped me a lot in the later stages of the project. Golden standard for NixOS configs.
- [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config) — Great docs and unique way of enabling modules. Very interesting config.
