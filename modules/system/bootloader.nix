{...}: {
  flake = {
    nixosModules.bootloader = {...}: {
      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        limine = {
          enable = true;
          efiSupport = true;
          biosSupport = false;
          enableEditor = true;
          maxGenerations = 10;
        };
      };
    };
  };
}
