{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hardware-CHANGEME = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
      hardware.facter.reportPath = ./facter.json;
      imports = [
        # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
        inputs.nixos-hardware.nixosModules.common-pc
      ];
    };
  };
}
