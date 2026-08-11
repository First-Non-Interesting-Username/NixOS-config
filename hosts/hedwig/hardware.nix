{
  pkgs,
  lib,
  modulesPath,
  config,
  ...
}: {
  imports = [
    (modulesPath + "/virtualisation/proxmox-lxc.nix")
  ];

  boot.isContainer = true;

  systemd.suppressedSystemUnits = [
    "dev-mqueue.mount"
    "sys-kernel-debug.mount"
    "sys-fs-fuse-connections.mount"
  ];

  boot.loader.limine.enable = lib.mkForce false;
  boot.loader.efi.canTouchEfiVariables = lib.mkForce false;
  boot.loader.grub.enable = lib.mkForce false;
  boot.loader.systemd-boot.enable = lib.mkForce false;

  hardware.enableAllFirmware = lib.mkForce false;
  hardware.firmware = lib.mkForce [];
  hardware.facter.reportPath = lib.mkForce null;

  zramSwap.enable = lib.mkForce false;

  networking.networkmanager.enable = lib.mkForce false;

  system.stateVersion = "26.11";

  home-manager.users.${config.custom.user.name}.home.stateVersion = "26.11";
}
