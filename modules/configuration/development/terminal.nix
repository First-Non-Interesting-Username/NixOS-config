{self, ...}: {
  flake = {
    nixosModules.terminal = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/foot"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.foot];
      };
    };
  };
}
