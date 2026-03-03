{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hardware-Minimal = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # 8 random digits/lowercase numbers
      networking.hostId = "2b8779d2";

      boot.initrd.availableKernelModules = [
        "ahci"
        "nvme"
        "sd_mod"
        "xhci_pci"
      ];

      hardware.enableRedistributableFirmware = true;

      imports = [
        self.nixosModules.disks-Minimal
      ];
    };
  };
}
