# Applications

## self.nixosModules.audio

- Enables pipewire, with few supporting packages and compatiblity layers.

## self.nixosModules.flatpak

- Imports nix-flatpak for convinence and few extra options.
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
- Enables Gamemode and Gamescope in a system level, for better performance and simplier gaming.
- (Installs Factorio with Space Age DLC.)
- Installs Prismlauncher
- Installs Heroic games launcher and gives it the access to Gamemode, Gamescope and Mangohud.
- Sets up enviroment variables for AMD and Intel GPUs to explicitly use the Mesa drivers.
- Enables Mangohud.
- Installs Lutris with Proton GE and everything it needs.

## self.nixosModules.printing

- Sets up automatic printer discovery.
- Enables cups with web UI at `http://localhost:631`.

## self.nixosModules.sunshine

IMPERATIVE:

- Go to `https://localhost:47990`.
- Set up Sunshine as you would on normal Linux. You can follow some tutorial for that.

- Sets up Sunshine service.
- Makes fixes neccessary for it to work on Wayland.

## self.nixosModules.moonlight

- Installs Moonlight package.

## self.nixosModules.virtualization-desktop

- Enables Podman with docker compatiblity and socket.
- Installs Distrobox with Distroshelf convinience package.

## self.nixosModules.virtualization-server

- Enables Podman with DNS working between containers.
