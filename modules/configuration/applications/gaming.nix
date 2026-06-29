_: {
  flake = {
    nixosModules.gaming = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              "homes"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {
        config,
        lib,
        ...
      }: {
        home.activation.createGboxDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p "${config.home.homeDirectory}/homes/Gbox"
        '';
        programs.distrobox = {
          settings = {
            container_manager = "podman";
            container_generate_entry = 1;
            container_user_custom_home = "${config.home.homeDirectory}/homes/default";
          };
          enable = true;
          containers = {
            Gbox = {
              image = "ghcr.io/first-non-interesting-username/gbox-gnome:20260628";
              init = false;
              root = false;
              start_now = false;
              exported_apps = "steam lutris protonup-qt prismlauncher";
              init_hooks = "/usr/local/prism-instance-bootstrap.sh";
              home = "${config.home.homeDirectory}/homes/Gbox";
            };
          };
        };
      };
    };
  };
}
