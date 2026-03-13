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
      environment.systemPackages = with pkgs.kdePackages; [
        qtstyleplugin-kvantum
      ];
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
        qtstyleplugin-kvantum
      ];
    };
  };
}
