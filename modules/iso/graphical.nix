_: {
  flake = {
    nixosModules.iso-graphical = {
      pkgs,
      modulesPath,
      username,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
      ];

      environment.defaultPackages = with pkgs; [
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
        nano
        netcat
      ];
      home-manager.users.${username} = {
        osConfig,
        lib,
        ...
      }: {
        home.stateVersion = lib.mkForce osConfig.system.stateVersion;
      };
    };
  };
}
