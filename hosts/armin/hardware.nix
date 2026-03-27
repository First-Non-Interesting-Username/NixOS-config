{
  pkgs,
  lib,
  inputs,
  username,
  ...
}: {
  zramSwap = {
    enable = true;
  };

  hardware = {
    firmware = [pkgs.linux-firmware];
    cpu.amd.updateMicrocode = true;
    facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
      reportPath = ./facter.json;
    };
    enableAllFirmware = lib.mkForce true;
  };

  boot = {
    kernelModules = [
      "mt7921e"
      "kvm-amd"
    ];
    initrd = {
      kernelModules = ["amdgpu"];
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "usb_storage"
        "sd_mod"
        "rtsx_pci_sdmmc"
      ];
    };
    supportedFilesystems = ["btrfs"];
    kernelParams = ["nohibernate"];
  };

  system.stateVersion = "26.05";

  imports = [
    inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  home-manager.users.${username} = _: {
    home.stateVersion = "26.05";
  };
}
