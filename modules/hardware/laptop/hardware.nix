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

        # 8 random digits/lowercase numbers
        networking.hostId = "00000000";

        # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
        hardware.facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
          reportPath = ./facter.json;
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
