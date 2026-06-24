# Applications

## nixosModules.audio

- Enables pipewire, with few supporting packages and compatibility layers.

## nixosModules.browser

IMPERATIVE:

- Open Firefox.
- Enable all extensions and log in to Proton Pass.

###

- Installs Firefox.
- Sets it as a default browser.
- Changes few settings to my preferred values.
- Adds few extensions.
- Adds MyNixOS as a search engine.
- Sets DDG as a default search engine.

## nixosModules.flatpak

- Imports nix-flatpak for convenience and few extra options.
- Enables flatpak service.
- Makes it so unmanaged flatpaks are automatically uninstalled.
- Updates all flatpaks on system rebuild.
- Adds flathub remote.
- Installs Flatseal flatpak for temporary imperative flatpak management.
- Installs Warehouse, a multitool app for flatpak management.

## nixosModules.gaming

Secrets: factorio_token

WIP

- (Sets up Factorio package with my user token and username so it can be downloaded.)
- Enables Steam system package with Proton GE, Gamescope session and open firewall.
- Enables Gamemode and Gamescope in a system level, for better performance and simpler gaming.
- (Installs Factorio with Space Age DLC.)
- Installs PrismLauncher
- Installs Heroic games launcher and gives it the access to Gamemode, Gamescope and Mangohud.
- Sets up environment variables for AMD and Intel GPUs to explicitly use the Mesa drivers.
- Enables Mangohud.
- Installs Lutris with Proton GE and everything it needs.

## nixosModules.printing

- Sets up automatic printer discovery.
- Enables cups with web UI at `http://localhost:631`.

## nixosModules.programs

- Installs Obsidian (It will hopefully be replaced by Neovim in some time).
- Installs KDE Connect.

## nixosModules.vicinae

- Enables vicinae with opinionated config.

## nixosModules.sunshine

IMPERATIVE:

- Go to `https://localhost:47990`.
- Set up Sunshine as you would on normal Linux. You can follow some tutorial for that.

###

- Sets up Sunshine service.
- Makes fixes necessary for it to work on Wayland.

## nixosModules.moonlight

- Installs Moonlight package.

## nixosModules.virtualization-desktop

- Enables Podman with docker compatibility and socket.
- Installs Distrobox with Distroshelf convenience package.

## nixosModules.virtualization-server

- Enables Podman with DNS working between containers.

# Desktop

## nixosModules.input

- Sets Polish keyboard layout with caps/escape swap.
- Sets natural scrolling for both mouse and touchpad.
- Enables Steam Controller udev rules.

## nixosModules.noctalia

Custom shell environment for Hyprland or Niri with the following features:

- Bar: Top-positioned simple bar with launcher, clock, system monitor, active window, media mini, workspace, tray, notifications, battery, volume, brightness, and control center.
- Control Center: Network, Bluetooth, wallpaper selector, notifications, power profile, keep awake, night light shortcuts.
- App Launcher: Clipboard history, terminal integration, searchable settings and windows.
- Dock: Bottom-positioned auto-hide dock with pinned apps.
- Notifications: Top-right notifications with history.
- Session Menu: Lock, suspend, hibernate, logout, reboot, shutdown options.
- System Monitor: CPU, memory, disk, network monitoring with configurable thresholds.
- Lock Screen: Compact lock screen with session buttons.
- Weather: Location-based weather display (Kielce default).

## nixosModules.theme

- Enables Qt with Breeze theme.
- Enables GTK theming.
- Enables Stylix for comprehensive theming.

NixOS Logo designed by Tim Cuthbertson (@timbertson).

The NixOS logo is licensed under the [Creative Commons Attribution 4.0
International License](http://creativecommons.org/licenses/by/4.0/).

### Theme Configuration

- Base16 Scheme: Gruvbox Dark.
- Cursor: Bibata Modern Ice (24px).
- Icon Theme: Papirus (Dark/Light variants).
- Fonts:
  - Monospace: JetBrains Mono Nerd Font.
  - Sans Serif: DejaVu Sans.
  - Serif: DejaVu Serif.
  - Emoji: Noto Color Emoji.
- Wallpaper: Custom SVG-based Gruvbox-inspired wallpaper.

### Disabled Targets

Disables Stylix targets for: VSCode colors, KDE, Qt, and Floorp.

## nixosModules.wayland

- Enables GPU/graphics drivers with 32-bit support (Steam/Wine compatibility).
- Enables PolicyKit for privileged operations.
- Sets Wayland system environment variables.
- Enables D-Bus.
- Installs core Wayland packages.

# Development

## nixosModules.direnv

- Installs Direnv with Zsh integration and nix-direnv.

## nixosModules.git

Secrets: github_pat

IMPERATIVE:

- Run `gh ssh-key add ~/.ssh/id_ed25519.pub` to add the SSH key of the machine to github.

###

- Installs Git and GH.
- Installs Onefetch, for Fastfetch like overviews of Git repos.
- Sets up Git with username and email provided by the user.
- Sets default branch to main (Why isn't it default?).
- Sets up GH with default git protocol being SSH and automatically logs you in.
- Creates `commit` alias for faster commit creation (aliased to `git add . && git commit -m`).

## nixosModules.secretless-git

- Installs Git and GH.
- Installs Onefetch, for Fastfetch like overviews of Git repos.
- Sets up Git with username and email provided by the user.
- Sets default branch to main (Why isn't it default?).
- Creates `commit` alias for faster commit creation (aliased to `git add . && git commit -m`).

## nixosModules.IDE

WIP

- Installs VSCodium with Nix-ide extension and few essential settings.
- Installs Micro.
- Installs Zed with few essential settings and Nix LSP support.
- Installs Nil and Alejandra.
- Sets VSCodium as an `EDITOR` and `VISUAL`.

## nixosModules.nix

- Enables essential experimental nix features.
- Unlocks the whole CPU for nix builds.
- Disables channels.
- Allows unfree packages and disallows broken ones.
- Installs this configuration in `/etc/nixos` in read-only mode.

## nixosModules.opencode

- Installs Opencode.

## nixosModules.shell

- Installs Zsh systemwide and sets it up for your user.
- Enables Zsh for the user with few preferences set how I want them.

###

Enables and sets up:

- Nix-index
- Starship prompt
- Atuin
- Eza
- Zoxide
- Tealdeer
- Television
- Pay-respects
- Lazygit
- Btop
- Bat
- Fd
- Fastfetch
- Trash CLI
- Ugrep

## nixosModules.terminal

WIP

- Installs Foot and Kitty.

# ISO

## nixosModules.iso

- Installs few basic packages: text editors, installers.
- Embedds my flake into the ISO.

## nixosModules.iso-graphical

- Imports the graphical installation CD module from Nixpkgs.
- Adds few additiond packages.

## nixosModules.iso-terminal

- Imports the base installation CD module from Nixpkgs.
- Includes everything in the base iso module.

# Services

## nixosModules.nas-server

PERSONAL

- Sets up a NAS server

## nixosModules.nas-client

PERSONAL

- Sets up a NAS client for above server

## nixosModules.secrets

- Sets up secrets management system with sops.
- Sets host SSH key as a default key for age, which is used for sops.

## nixosModules.ssh

Secrets: ssh_keys/private/${hostname}, ssh_keys/public/${hostname}

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories with sops.

## nixosModules.secretless-ssh

PERSONAL
DON'T USE ON PRODUCTION MACHINES

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts publically available SSH public and private keys to right directories.

## nixosModules.ssh-debug

- Opens SSH for everyone, with root login.

## nixosModules.ssh-server

- Sets up SSH server on port 6767 (Yes, this is a 67 joke).
- Sets fail2ban for SSH.

## nixosModules.update

- Installs Nh and sets up automatic cleaning.
- Sets up Nh flake to remote of my flake.
- Enables weekly store optimizes.
- Enables daily automatic updates.

## nixosModules.web-expose

This is an actual module, with options. By itself, it will do nothing, you must configure it.

This module was created with heavy assistance of AI. I had the final word in everything and I manually fixed few issues, but I'm absolutely sure there are more of them.

- Runs Traefik with Let's Encrypt DNS-01 certificates, HTTP→HTTPS redirect, and modern TLS defaults.
- Distinguishes public (internet-facing) and LAN-only services, applying IP allowlists, rate limits, and security headers automatically.
- Enforces authentication policies (bypass, one_factor, two_factor, deny) on a per-router basis with subjects, networks, and resource ACLs.
- Provides a lightweight LDAP directory for Authelia, with automatic user and group bootstrapping on first startup.
- Exposes Authelia as an OpenID Connect identity provider for native OIDC applications (e.g., Grafana, Portainer).
- Optionally uses traefik-oidc-auth to make Traefik itself an OIDC client, enabling SSO for legacy apps without native OIDC support.
- All credentials, tokens, and keys are passed via external files (sops-nix compatible) with enforced service-user ownership.

Docs of the module are available [here](./web-expose.md)

# System

## nixosModules.bootloader

- Enables Limine bootloader and sets it up according to my preferences.

## nixosModules.impermanence

Special args: impermanence (required for impermanence to function, true/false)

- Enables impermanence. Make sure your system is prepared for it.

## nixosModules.kernel-laptop

- Enables Linux Zen kernel and kernel params for small battery life gains.

## nixosModules.kernel-desktop

- Enables CachyOS kernel with bore scheduler and lto for small performance gains.

## nixosModules.locale

- Sets up polish locale for everything, except language.
- Sets Europe/Warsaw as a time zone.

## nixosModules.networking-desktop

PERSONAL

Secrets: wifi_password

Special args: hostname

- Sets up networking for a desktop style machine, with firewall and network manager.
- Sets up Bluetooth.
- Logs in to my home wifi network.

## nixosModules.secretless-networking-desktop

Special args: hostname

IMPERATIVE:

- Log in to your wifi

###

- Sets up networking for a desktop style machine, with firewall and network manager.
- Sets up Bluetooth.

## nixosModules.networking-server

PERSONAL

- Sets up networking for MY server, in MY home network specifically.

## nixosModules.networking-minimal

Special args: hostname

- Sets up networking for a desktop style machine, with firewall and network manager.

## nixosModules.power

- Enables the UPower daemon, which is a D-Bus service that provides power management info to applications.
- Enables the Power Profiles Daemon, which exposes three power profiles via D-Bus .

# User

## nixosModules.home-manager

- Enables Home Manager.
- Lets Home Manager manage itself.

## nixosModules.user

Configured via `custom.user` options:

- `custom.user.enable` - Enable the user module.
- `custom.user.name` - Username.
- `custom.user.hashedPasswordFile` - Path to hashed password file.
- `custom.user.password` - Initial password (plaintext).
- `custom.user.hashedPassword` - Hashed password string.

- Creates a user with the configured name.
- Adds it to various groups.
- Sets a password for it with the configured option.

## nixosModules.xdg

- Creates xdg directories, with location based on impermanence enablement
