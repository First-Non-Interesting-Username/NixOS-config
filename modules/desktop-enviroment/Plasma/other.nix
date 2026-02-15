{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-other = {
      pkgs,
      lib,
      config,
      ...
    }: {
      xdg.portal = {
        enable = true;
        extraPortals = [
          pkgs.kdePackages.xdg-desktop-portal-kde
        ];
      };
    };
    homeModules.plasma-other = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
