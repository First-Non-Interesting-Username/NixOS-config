{ self, ... }:
{
  flake = {
    nixosModules.iso-graphical =
      {
        pkgs,
        modulesPath,
        username,
        ...
      }:
      {
        imports = [
          (modulesPath + "/installer/cd-dvd/installation-cd-graphical-base.nix")
          self.nixosModules.iso
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
        ];
      };
  };
}
