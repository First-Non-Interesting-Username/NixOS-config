_: {
  flake = {
    nixosModules.gaming = {
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              "homes"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {config, ...}: {
        programs.distrobox = {
          settings = {
            container_manager = "podman";
            container_generate_entry = 1;
            container_user_custom_home = "${config.home.homeDirectory}/homes/default";
          };
          enable = true;
          containers = {
            Gbox = {
              image = "ghcr.io/first-non-interesting-username/gbox-gnome:20260620";
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
