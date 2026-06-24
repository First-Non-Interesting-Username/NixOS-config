_: {
  flake = {
    nixosModules.direnv = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".local/share/direnv"
            ];
          };
        };
      };

      home-manager.users.${username} = _: {
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
