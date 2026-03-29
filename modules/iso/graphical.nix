_: {
  flake = {
    nixosModules.iso-graphical = {
      pkgs,
      modulesPath,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
      ];

      services.spice-vdagentd.enable = true;
      services.qemuGuest.enable = true;
      virtualisation.vmware.guest.enable = pkgs.stdenv.hostPlatform.isx86;
      virtualisation.hypervGuest.enable =
        pkgs.stdenv.hostPlatform.isx86 || pkgs.stdenv.hostPlatform.isAarch64;
      services.xe-guest-utilities.enable = pkgs.stdenv.hostPlatform.isx86;

      environment.defaultPackages = with pkgs; [
        gparted
        parted
        diskus
        nvme-cli
        hdparm
        sdparm
        pciutils
        usbutils
        lshw
        dmidecode
        mesa-demos
        cryptsetup
        vlc
      ];
    };
  };
}
