{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.flatpak = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      services.flatpak.enable = true;
      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-gtk];
        config.common.default = "*";
      };
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        ...
      }: {
        imports = [
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];

        services.flatpak = {
          update.onActivation = true;
          remotes = [
            {
              name = "flathub";
              location = "https://dl.flathub.org/repo/flathub.flatpakrepo";
            }
          ];
          packages = [
            "com.github.tchx84.Flatseal"
          ];
          uninstallUnmanaged = true;
        };

        home.packages = with pkgs; [
          warehouse
        ];
      };
    };
  };
}
