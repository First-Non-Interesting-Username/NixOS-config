{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland-other = {
      pkgs,
      lib,
      config,
      ...
    }: {
      xdg.portal = {
        enable = true;
        config.common.default = "*";
      };
      programs.dconf.enable = true;
    };
    homeModules.hyprland-other = {
      pkgs,
      lib,
      config,
      ...
    }: {
      stylix.targets.qt = {
        enable = true;
        platform = "qtct";
      };
      dconf = {
        enable = true;
        #settings = {};
      };
    };
  };
}
