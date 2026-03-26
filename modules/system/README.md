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

Special args: hostname

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
