{self, ...}: {
  flake = {
    nixosModules.terminal = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".local/share/foot"
            ];
          };
        };
      };

      home-manager.users.${username} = {pkgs, ...}: {
        home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.foot];
      };
    };
  };
}
