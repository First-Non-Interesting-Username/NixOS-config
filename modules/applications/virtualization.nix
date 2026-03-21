{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.virtualization-desktop =
      {
        pkgs,
        lib,
        config,
        username,
        impermanence,
        ...
      }:
      {
        # We use 'config' as the single top-level attribute
        config = lib.mkMerge [
          # Part 1: Conditional persistence
          (lib.mkIf impermanence {
            environment.persistence."/persist" = {
              directories = [ "/var/lib/containers" ];
              users.${username} = {
                directories = [
                  ".local/share/containers"
                  ".config/containers"
                  ".local/share/distrobox"
                ];
              };
            };
          })

          # Part 2: Your standard configuration (moved inside config)
          {
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

            home-manager.users.${username} =
              { pkgs, ... }:
              {
                home.packages = [ pkgs.distroshelf ];
                programs.distrobox.enable = true;
              };
          }
        ];
      };

    nixosModules.virtualization-server =
      {
        pkgs,
        lib,
        config,
        username,
        impermanence,
        ...
      }:
      {

        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/containers"
            ];
            users.${username} = {
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
