{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-apps = {
      pkgs,
      lib,
      config,
      ...
    }: {
    };
    homeModules.plasma-apps = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.packages = with pkgs.kdePackages; [
        dolphin
        kate
        gwenview
        elisa
        ark
        plasma-systemmonitor
        kcalc
        spectacle
        merkuro
        kclock
        kweather
        konsole
        kolourpaint
        okular
        isoimagewriter
      ];
    };
  };
}
