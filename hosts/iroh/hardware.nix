{
  pkgs,
  inputs,
  username,
  ...
}: {
  boot = {
    initrd.availableKernelModules = [
      "ahci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "nvme"
    ];
    supportedFilesystems = [
      "btrfs"
      "xfs"
    ];
  };

  hardware = {
    facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
      reportPath = ./facter.json;
    };
    cpu.intel.updateMicrocode = true;
    usbStorage.manageShutdown = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-vaapi-driver
        libva-vdpau-driver
        libvdpau-va-gl
      ];
    };
  };

  systemd.tmpfiles.rules = [
    "d /mnt/storage 0755 ${username} users -"
  ];

  services = {
    btrfs.autoScrub = {
      enable = true;
      fileSystems = ["/"];
      interval = "monthly";
    };
    udev.extraRules = ''
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq""
    '';
  };

  system.stateVersion = "26.11";

  imports = [
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  home-manager.users.${username} = _: {
    home.stateVersion = "26.11";
  };
}
