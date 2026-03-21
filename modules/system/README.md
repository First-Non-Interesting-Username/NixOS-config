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

- Sets up networking for MY server, in MY home network specyfically.

## self.nixosModules.networking-minimal

- Sets up networking for a desktop style machine, with firewall and network manager.
- Sets up Bluetooth.

## self.nixosModules.power

- Enables the UPower daemon, which is a D-Bus service that provides power management info to applications.
- Enables the Power Profiles Daemon, which exposes three power profiles via D-Bus .
