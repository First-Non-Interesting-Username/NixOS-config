{ self, ... }:
{
  flake = {
    nixosModules.iso =
      {
        lib,
        config,
        pkgs,
        username,
        ...
      }:
      {
        imports = [
          "${pkgs.path}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ];

        hardware.enableAllHardware = true;

        isoImage = {
          makeEfiBootable = true;
          makeUsbBootable = true;
        };

        swapDevices = lib.mkImageMediaOverride [ ];
        fileSystems = lib.mkImageMediaOverride config.lib.isoFileSystems;
        boot.initrd.luks.devices = lib.mkImageMediaOverride { };

        environment.defaultPackages = with pkgs; [
          rsync
          nano
          netcat
          smartctl
        ];

        system.stateVersion = lib.mkDefault lib.trivial.release;
      };
  };
}
