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
        config = lib.mkIf impermanence {
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
        home-manager.users.${username} =
          {
            pkgs,
            lib,
            config,
            ...
          }:
          {
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
