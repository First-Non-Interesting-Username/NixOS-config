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

  kernelPackages = pkgs.linuxPackages_zen;

  services = {
    scx = {
      enable = true;
      scheduler = "scx_bpfland";
    };
    system76-scheduler.enable = true;
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
    kernelParams = [
      "nohibernate"
      "mem_sleep_default=deep"
      "amd_pstate=active"
      "nvme.noacpi=1"
    ];
  };

  systemd.services.set-default-power-profile = {
    description = "Set default power profile to power-saver";
    after = ["power-profiles-daemon.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl set power-saver";
    };
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
