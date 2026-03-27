{
  pkgs,
  inputs,
  username,
  modulesPath,
  ...
}: {
  services.qemuGuest.enable = true;

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ahci"
    "xhci_pci"
    "usbhid"
    "sr_mod"
  ];

  boot.supportedFilesystems = [
    "btrfs"
    "xfs"
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-vaapi-driver
      libva-vdpau-driver
      libvdpau-va-gl
    ];
  };

  systemd.tmpfiles.rules = [
    "d /mnt/data    0755 ${username} users -"
    "d /mnt/storage 0755 ${username} users -"
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
      interval = "monthly";
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="sdc", ATTR{queue/scheduler}="bfq"
    '';
  };

  system.stateVersion = "26.05";

  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  home-manager.users.${username} = {...}: {
    home.stateVersion = "26.05";
  };
}
