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
      modulesPath,
      ...
    }: {
      services.qemuGuest.enable = true;

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

      hardware.opengl = {
        enable = true;
        extraPackages = with pkgs; [
          intel-media-driver
          vaapiIntel
          vaapiVdpau
          libvdpau-va-gl
        ];
      };

      imports = [
        self.nixosModules.disks-Server
        [(modulesPath + "/profiles/qemu-guest.nix")];
      ];
    };
  };
}
