{...}: {
  flake = {
    nixosModules.plasma-apps = {
      pkgs,
      username,
      ...
    }: {
      environment.systemPackages = with pkgs.kdePackages; [
        qtstyleplugin-kvantum
      ];

      home-manager.users.${username} = {pkgs, ...}: {
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
  };
}
