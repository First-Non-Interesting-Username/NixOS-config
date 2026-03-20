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
      username,
      ...
    }: {
      xdg.portal = {
        enable = true;
        config.common.default = "*";
      };
      programs.dconf.enable = true;

      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        ...
      }: {
        dconf = {
          enable = true;
          #settings = {};
        };
      };
    };
  };
}
