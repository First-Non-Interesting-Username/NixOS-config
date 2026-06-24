_: {
  flake = {
    nixosModules.virtualization-desktop = {
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [
            "/var/lib/containers"
          ];
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/containers"
              ".config/containers"
              ".local/share/distrobox"
              ".local/share/applications/"
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
      impermanence,
      config,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
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
    };
  };
}
