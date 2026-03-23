# Applications

## self.nixosModules.audio

- Enables pipewire, with few supporting packages and compatibility layers.

## self.nixosModules.browser

WIP

IMPERATIVE:

- Open Floorp.
- Enable all extensions and log in to Proton Pass.

###

- Installs Floorp.
- Sets it as a default browser.
- Changes few settings to my preferred values.
- Adds few extensions.
- Adds MyNixOS as a search engine.
- Sets DDG as a default search engine.

## self.nixosModules.flatpak

- Imports nix-flatpak for convenience and few extra options.
- Enables flatpak service.
- Makes it so unmanaged flatpaks are automatically uninstalled.
- Updates all flatpaks on system rebuild.
- Adds flathub remote.
- Installs Flatseal flatpak for temporary imperative flatpak management.
- Installs Warehouse, a multitool app for flatpak management.

## self.nixosModules.gaming

WIP

- (Sets up Factorio package with my user token and username so it can be downloaded.)
- (Enables Steam system package with Proton GE, Gamescope session and open firewall.)
- Enables Gamemode and Gamescope in a system level, for better performance and simpler gaming.
- (Installs Factorio with Space Age DLC.)
- Installs PrismLauncher
- Installs Heroic games launcher and gives it the access to Gamemode, Gamescope and Mangohud.
- Sets up environment variables for AMD and Intel GPUs to explicitly use the Mesa drivers.
- Enables Mangohud.
- Installs Lutris with Proton GE and everything it needs.

## self.nixosModules.printing

- Sets up automatic printer discovery.
- Enables cups with web UI at `http://localhost:631`.

## self.nixosModules.programs

- Installs Obsidian (It will hopefully be replaced by Neovim in some time).
- Installs KDE Connect.

## self.nixosModules.sunshine

IMPERATIVE:

- Go to `https://localhost:47990`.
- Set up Sunshine as you would on normal Linux. You can follow some tutorial for that.

###

- Sets up Sunshine service.
- Makes fixes necessary for it to work on Wayland.

## self.nixosModules.moonlight

- Installs Moonlight package.

## self.nixosModules.virtualization-desktop

- Enables Podman with docker compatibility and socket.
- Installs Distrobox with Distroshelf convenience package.

## self.nixosModules.virtualization-server

- Enables Podman with DNS working between containers.


# Desktop Environments

## self.nixosModules.plasma

- Enables KDE Plasma DE

## self.nixosModules.hyprland

- Enables Hyprland.


# Desktop

## self.nixosModules.input

- Sets polish keyboard layout with caps swap.
- Sets natural scrolling for both mouse and touchpad.
- Enables Steam Controller udev rules.

## self.nixosModules.theme

- Enables Qt and sets the theme to breeze.
- Enables GTK.
- Enables Stylix.

###

- Sets:
- Theme to Gruvbox Dark.
- Cursor to Bibata Modern Ice.
- Icon theme to Papirus.
- Monospace font to JetBrains Mono Nerd Font.
- Sans Serif font to DejaVu Sans.
- Serif font to DejaVu Serif.
- Emoji font to Noto Color Emoji.

###

- Disables the following stylix targets: Vscode colors, KDE, QT and Floorp.

## self.nixosModules.wayland

- Enables GPU/graphics drivers, including 32-bit support (needed for things like Steam/Wine).
- Enables PolicyKit, a system for controlling privileged operations.
- Sets system-wide environment variables that tell apps to use Wayland instead of XWayland.
- Enables D-Bus.
- Installs core Wayland packages.


# Development

## self.nixosModules.direnv

- Installs Direnv with Zsh integration and nix-direnv.

## self.nixosModules.git

IMPERATIVE:

- Run `gh ssh-key add ~/.ssh/id_ed25519.pub` to add the SSH key of the machine to github.

###

- Installs Git and GH.
- Installs Onefetch, for Fastfetch like overviews of Git repos.
- Sets up Git with username and email provided by the user.
- Sets default branch to main (Why isn't it default?).
- Sets up GH with default git protocol being SSH and automatically logs you in.

## self.nixosModules.IDE

WIP

- Installs VSCodium with Nix-ide extension and few essential settings.
- Installs Micro.
- Installs Zed with few essential settings and Nix LSP support.
- Installs Nil and Alejandra.
- Sets VSCodium as an `EDITOR` and `VISUAL`.

## self.nixosModules.nix

- Enables essential experimental nix features.
- Unlocks the whole CPU for nix builds.
- Disables channels.
- Allows unfree packages and disallows broken ones.

## self.nixosModules.shell

- Installs Zsh systemwide and sets it up for your user.
- Enables Zsh for the user with few preferences set how I want them.

###

- Enables and sets up:
- Nix-index.
- Starship prompt.
- Atuin.
- Eza.
- Zoxide.
- Tealdeer.
- Television
- Pay-respects.
- Lazygit
- Btop.
- Bat.
- Fd.
- Fastfetch.
- Trash CLI.
- Ugrep.

## self.nixosModules.terminal

WIP

- Installs Foot and Kitty.


# Services

## self.nixosModules.nps

PERSONAL

IMPERATIVE:

- Set up authelia one time password 2FA.
- Set up the ARR stack as you would on normal server

###

- Sets up services for my home server.

## self.nixosModules.secrets

- Sets up secrets management system with sops.
- Sets host SSH key as a default key for age, which is used for sops.

## self.nixosModules.secrets-impermanence

- Sets up secrets management system with sops.
- Sets host SSH key with path changed to include persist directory as a default key for age, which is used for sops.

## self.nixosModules.ssh

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories with sops.

## self.nixosModules.ssh-impermanence

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories (now with persist, so they work with impermanence) with sops.

## self.nixosModules.ssh-debug

- Opens SSH for everyone, with root login.

## self.nixosModules.ssh-server

- Sets up SSH server on port 6767 (Yes, this is a 67 joke).
- Sets fail2ban for SSH.

## self.nixosModules.update

- Installs Nh and sets up automatic cleaning.
- Sets up Nh flake to remote of my flake.
- Enables weekly store optimizes.
- Enables daily automatic updates.


# System

## self.nixosModules.bootloader

- Enables Limine bootloader and sets it up according to my preferences.

## self.nixosModules.kernel-laptop

- Enables Linux Zen kernel and kernel params for small battery life gains.

## self.nixosModules.kernel-desktop

- Enables CachyOS kernel with bore scheduler and lto for small performance gains.

## self.nixosModules.locale

- Sets up polish locale for everything, except language.
- Sets Europe/Warsaw as a time zone.

## self.nixosModules.networking-desktop

- Sets up networking for a desktop style machine, with firewall and network manager.
- Sets up Bluetooth.

## self.nixosModules.networking-server

PERSONAL

- Sets up networking for MY server, in MY home network specifically.

## self.nixosModules.networking-minimal

- Sets up networking for a desktop style machine, with firewall and network manager.
- Sets up Bluetooth.

## self.nixosModules.power

- Enables the UPower daemon, which is a D-Bus service that provides power management info to applications.
- Enables the Power Profiles Daemon, which exposes three power profiles via D-Bus .


# User

## self.nixosModules.home-manager

- Enables Home Manager.
- Lets Home Manager manage itself.

## self.nixosModules.user

- Creates a user with username passed via special arg.
- Adds it to various groups.
- Sets a password for it.

## self.nixosModules.user-debug

- Sets root password to `debug`.


