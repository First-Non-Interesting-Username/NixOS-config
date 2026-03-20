{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.virtualization-desktop = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      virtualisation.podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
      virtualisation.waydroid.enable = true;
      boot.kernelModules = [
        "binder_linux"
        "ashmem_linux"
      ];
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        ...
      }: {
        home.packages = with pkgs; [
          waydroid-helper
          distroshelf
        ];
        programs = {
          lazydocker.enable = true;
          distrobox = {
            enable = true;
          };
        };
      };
    };
    nixosModules.virtualization-server = {
      pkgs,
      lib,
      config,
      ...
    }: {
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
