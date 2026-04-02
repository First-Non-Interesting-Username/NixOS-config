# Applications

## nixosModules.audio

- Enables pipewire, with few supporting packages and compatibility layers.

## nixosModules.browser

WIP

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
- (Enables Steam system package with Proton GE, Gamescope session and open firewall.)
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
