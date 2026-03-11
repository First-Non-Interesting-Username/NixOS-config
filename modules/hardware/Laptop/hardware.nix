{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hardware-Laptop = {
      pkgs,
      lib,
      config,
      ...
    }: {
      zramSwap = {
        enable = true;
      };

      hardware = {
        firmware = [pkgs.linux-firmware];
        cpu.amd.updateMicrocode = true;
        # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
        facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
          reportPath = ./facter.json;
        };
      };
      hardware.enableAllFirmware = lib.mkForce true;
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
      };

      imports = [
        # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        inputs.nixos-hardware.nixosModules.lenovo-thinkpad-l14-amd

        self.nixosModules.disks-Laptop
        self.nixosModules.impermanence-Laptop
      ];
    };
  };
}
