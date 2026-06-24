_: {
  flake = {
    nixosModules.direnv = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/direnv"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = _: {
        programs = {
          direnv = {
            enable = true;
            enableZshIntegration = true;
            nix-direnv.enable = true;
          };
        };
      };
    };
  };
}
