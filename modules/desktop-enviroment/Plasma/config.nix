{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-config = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services = {
        xserver.enable = true;
        desktopManager.plasma6.enable = true;
      };
    };
    homeModules.plasma-config = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        inputs.plasma-manager.homeModules.plasma-manager
      ];

      programs.plasma = {
        enable = true;
      };
    };
  };
}
