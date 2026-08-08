_: {
  flake = {
    nixosModules.bootloader = _: {
      stylix.targets.limine.enable = true;

      boot.loader = {
        efi = {
          canTouchEfiVariables = true;
          efiSysMountPoint = "/boot";
        };

        limine = {
          enable = true;
          efiSupport = true;
          biosSupport = false;
          maxGenerations = 10;

          secureBoot = {
            enable = true;
            autoGenerateKeys = true;
            autoEnrollKeys = {
              enable = true;
              extraArgs = [
                "--firmware-builtin"
              ];
            };
          };
        };
      };
    };
  };
}
