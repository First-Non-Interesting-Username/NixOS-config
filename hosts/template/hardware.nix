{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: {
  zramSwap = {
    enable = true;
  };

  hardware = {
    firmware = [pkgs.linux-firmware];
    # Here you can add other hardware. options, such as microcode updates
    # sudo nix run --option experimental-features "nix-command flakes" nixpkgs#nixos-facter -- -o facter.json
    facter = lib.optionalAttrs (builtins.pathExists ./facter.json) {
      reportPath = ./facter.json;
    };
  };
  hardware.enableAllFirmware = lib.mkForce true;
  boot = {
    kernelModules = [];
    initrd = {
      kernelModules = [];
      availableKernelModules = [];
    };
    supportedFilesystems = [];
    kernelParams = [];
  };

  imports = [
    # https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
    # Add nixos-hardware modules for your hardware here
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];
}
