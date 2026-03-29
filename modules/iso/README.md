# ISO

## nixosModules.iso

- Imports the base installation CD module from Nixpkgs.
- Enables all hardware support for maximum compatibility.
- Makes the image bootable on both EFI and USB.
- Includes basic packages: Rsync, Nano, Netcat, Smartctl.

## nixosModules.iso-graphical

- Imports the graphical installation CD module from Nixpkgs.
- Enables guest agents for virtual machines: SPICE, QEMU, VMware, Hyper-V, XE.
- Includes disk management packages: Gparted, Parted, Diskus, Nvme-cli, Hdparm, Sdparm.
- Includes hardware utilities: Pciutils, Usbutils, Lshw, Dmidecode.
- Includes recovery and media tools: Photorec, Cryptsetup, VLC, Mesa-demos.
