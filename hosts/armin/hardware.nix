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
    supportedFilesystems = ["btrfs"];
    kernelParams = ["nohibernate"];
  };

  system.stateVersion = "26.05";

  imports = [
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    inputs.disko.nixosModules.disko
    ./disko.nix
  ];

  home-manager.users.${username} = _: {
    home.stateVersion = "26.05";
  };
}
