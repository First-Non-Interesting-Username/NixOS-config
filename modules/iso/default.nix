_: {
  flake = {
    nixosModules.iso = {
      lib,
      config,
      pkgs,
      modulesPath,
      username,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
      ];

      hardware.enableAllHardware = true;

      isoImage = {
        makeEfiBootable = true;
        makeUsbBootable = true;
      };

      swapDevices = lib.mkImageMediaOverride [];
      fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;
      boot.initrd.luks.devices = lib.mkImageMediaOverride {};

      environment.defaultPackages = with pkgs; [
        rsync
        nano
        netcat
      ];

      system.stateVersion = lib.mkDefault lib.trivial.release;

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
