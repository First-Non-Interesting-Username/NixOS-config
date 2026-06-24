{self, ...}: {
  flake = {
    nixosModules.terminal = {
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
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
