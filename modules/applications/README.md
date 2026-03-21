# Applications

## self.nixosModules.audio

Enables pipewire, with few supporting packages and compatiblity layers.

## self.nixosModules.flatpak

This does few things:

- Imports nix-flatpak for convinence and few extra options.
- Enables flatpak service.
- Makes it so unmanaged flatpaks are automatically uinstalled.
- Updates all flatpaks on system rebuild.
- Adds flathub remote.
- Installs Flatseal flatpak for temporary imperative flatpak management.
- Installs Warehouse, a multitool app for flatpak management.

## self.nixosModules.gaming

WIP
