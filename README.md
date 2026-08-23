# NixOS Config

A comprehensive OS-as-a-code solution based on NixOS (Work in progress).

[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/First-Non-Interesting-Username/NixOS-config)

> [!NOTE]
> This is a learning project in the first place.
> Please point out any issues you encounter. I will be more than happy to fix them and learn on my mistakes.

## Desktop screenshot

<img width="2560" height="1440" alt="a screenshot of gnome desktop" src="https://github.com/user-attachments/assets/f830e17d-349e-490e-a18c-c1f716d087b1" />

## Features

- Testing (that barely catches issue)
- Preservation
-

## Hosts Matrix

| Hostname | Motherboard / Laptop Model | CPU         | GPU               | RAM  | Primary Purpose  |
| -------- | -------------------------- | ----------- | ----------------- | ---- | ---------------- |
| armin    | Framework 13               | Ryzen 7640U | Radeon 760M       | 16GB | Desktop (GNOME)  |
| john     | N/A                        | N/A         | N/A               | N/A  | Installation ISO |
| wall-e   | N/A                        | N/A         | N/A               | N/A  | Installation ISO |
| template | N/A                        | N/A         | N/A               | N/A  | Other            |
| victim   | Gigabyte Eagle B650 AX     | Ryzen 7500F | Radeon RX 7800 XT | 32GB | Desktop (GNOME)  |

## Quickstart

The config can be tested using the bootable ISO from [github releases](https://github.com/First-Non-Interesting-Username/NixOS-config/releases).
Note that the ISO is hosted on sourceforge, so the download might be really slow.
Another way to acquire the ISO is to build it (with cache).
Run:

```bash
# Build CLI only ISO by replacing `john` with `wall-e`
nix build github:First-Non-Interesting-Username/NixOS-config#john
# Accept all prompts or you will be building the full ISO
```

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

## Documentation

Docs are built with Zensical and hosted on github pages ([link](https://first-non-interesting-username.github.io/NixOS-config/))

## Footnote

### Inspired by:

- [ryan4yin/nix-config](https://github.com/ryan4yin/nix-config) — Helped me a lot in the later stages of the project. Golden standard for NixOS configs.
- [wimpysworld/nix-config](https://github.com/wimpysworld/nix-config) — Great docs and unique way of enabling modules. Very interesting config.
- [Tarow/nix-podman-stacks](https://github.com/Tarow/nix-podman-stacks) - Extremely helpful for setting up my own homelab. Highly recommended.

### License

This project is licensed under the GNU General Public License v3.0 or later.
See the [LICENSE](LICENSE) file for details.
