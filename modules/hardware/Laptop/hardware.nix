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
        zramSwap = {
          enable = true;
        };

        boot = {
          kernelModules = [ "mt7921e" ];
          initrd.kernelModules = [ "amdgpu" ];
        };

        hardware = {
          enableRedistributableFirmware = lib.mkForce true;
          firmware = [ pkgs.linux-firmware ];
          cpu.amd.updateMicrocode = true;
          # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
          facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
            reportPath = ./facter.json;
          };
        };
        services.xserver = {
          videoDrivers = [ "amdgpu" ];
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
