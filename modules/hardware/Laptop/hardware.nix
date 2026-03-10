{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.hardware-Laptop =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        #zramSwap = {
        #  enable = true;
        #};

        #boot = {
        #  kernelModules = [
        #    "mt7921e"
        #    "kvm-amd"
        #  ];
        #  initrd = {
        #    kernelModules = [ "amdgpu" ];
        #    availableKernelModules = [
        #      "nvme"
        #      "xhci_pci"
        #      "usb_storage"
        #      "sd_mod"
        #      "rtsx_pci_sdmmc"
        #    ];
        #  };
        #};

        #hardware = {
        #  enableRedistributableFirmware = lib.mkForce true;
        #  firmware = [ pkgs.linux-firmware ];
        #  cpu.amd.updateMicrocode = true;
        # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
        #facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
        #reportPath = ./facter.json;
        #};
        #};
        #services.xserver = {
        #  videoDrivers = [ "amdgpu" ];
        #};

        hardware.enableAllFirmware = true;
        boot.initrd.availableKernelModules = [
          "nvme"
          "xhci_pci"
          "usb_storage"
          "sd_mod"
          "rtsx_pci_sdmmc"
        ];
        boot.initrd.kernelModules = [ ];
        boot.kernelModules = [ "kvm-amd" ];
        boot.extraModulePackages = [ ];
        swapDevices = [ ];
        hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableAllFirmware;

        imports = [
          # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
          #inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd

          self.nixosModules.disks-Laptop
          self.nixosModules.impermanence-Laptop
        ];
      };
  };
}
