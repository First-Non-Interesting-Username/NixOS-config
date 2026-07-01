{...}: {
  flake = {
    nixosModules.sudo = {
      lib,
      config,
      ...
    }: {
      security = {
        sudo.enable = false;
        sudo-rs.enable = true;
        polkit.extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (subject.isInGroup("wheel")) {
              if (action.id.indexOf("org.nixos.") == 0 || action.id.indexOf("org.freedesktop.systemd1.") == 0) {
                return polkit.Result.AUTH_ADMIN_KEEP;
              }
            }
          });
        '';
      };
    };
  };
}
