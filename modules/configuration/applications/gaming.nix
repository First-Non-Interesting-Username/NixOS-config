_: {
  flake = {
    nixosModules.gaming = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
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

        systemd.user.services.distrobox-home-manager = {
          Unit = {
            After = ["network-online.target"];
            Wants = ["network-online.target"];
          };
        };
        programs.distrobox = {
          settings = {
            container_manager = "podman";
            container_generate_entry = 1;
            container_user_custom_home = "${config.home.homeDirectory}/homes/default";
          };
          enable = true;
          containers = {
            Gbox = {
              image = "ghcr.io/first-non-interesting-username/gbox-gnome-amd:20260725";
              init = false;
              root = false;
              start_now = false;
              exported_apps = "steam lutris protonup-qt prismlauncher";
              init_hooks = "/usr/local/bin/prism-instance-bootstrap.sh";
              home = "${config.home.homeDirectory}/homes/Gbox";
            };
          };
        };
      };
    };
  };
}
