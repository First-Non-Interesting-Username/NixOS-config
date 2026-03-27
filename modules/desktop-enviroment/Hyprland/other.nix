{...}: {
  flake = {
    nixosModules.hyprland-other = {username, ...}: {
      xdg.portal = {
        enable = true;
        config.common.default = "*";
      };
      programs.dconf.enable = true;

      home-manager.users.${username} = {...}: {
        dconf = {
          enable = true;
          #settings = {};
        };
      };
    };
  };
}
