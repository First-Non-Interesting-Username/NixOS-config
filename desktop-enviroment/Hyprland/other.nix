_: {
  flake = {
    nixosModules.hyprland-other = {username, ...}: {
      xdg.portal = {
        enable = true;
        config.common.default = "*";
      };
      programs.dconf.enable = true;

      home-manager.users.${username} = _: {
        dconf = {
          enable = true;
          #settings = {};
        };
      };
    };
  };
}
