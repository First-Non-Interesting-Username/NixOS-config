{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hardware-Server = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.qemuGuestAgent.enable = true;

      # 8 random digits/lowercase numbers
      networking.hostId = "8c46cc1a";

      boot.initrd.availableKernelModules = [
        "virtio_pci"
        "virtio_blk"
        "virtio_scsi"
        "ahci"
        "xhci_pci"
        "usbhid"
        "sr_mod"
      ];

      imports = [
        self.nixosModules.disks-Server
      ];
    };
  };
}
