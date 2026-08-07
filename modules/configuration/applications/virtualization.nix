_: {
  flake = {
    nixosModules.virtualization-desktop = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories = [
            "/var/lib/containers"
          ];
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/containers"
              ".config/containers"
              ".local/share/distrobox"
              ".local/share/applications/"
              ".lima"
              ".cache/lima"
            ];
          };
        };
      };
      virtualisation = {
        podman = {
          enable = true;
          dockerCompat = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };
      boot.kernelModules = [
        "binder_linux"
        "ashmem_linux"
      ];
      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        home.packages = with pkgs; [
          lima
          distroshelf
        ];
        programs = {
          distrobox = {
            enable = true;
          };
        };
      };
    };

    nixosModules.virtualization-server = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories =
            lib.filter (
              d: let
                dir =
                  if builtins.isString d
                  then d
                  else d.directory;
              in
                !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
            ) [
              "/var/lib/containers"
            ];
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/containers"
              ".config/containers"
            ];
          };
        };
      };
      virtualisation = {
        containers.enable = true;
        podman = {
          enable = true;
          defaultNetwork.settings.dns_enabled = true;
        };
      };

      programs.distrobox = {
        settings = {
          container_manager = "podman";
          container_generate_entry = 1;
          container_user_custom_home = "${config.home.homeDirectory}/homes/default";
        };
        enableSystemdUnit = true;
        enable = true;
      };
    };
  };
}
