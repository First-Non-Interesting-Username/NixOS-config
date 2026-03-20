{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.direnv =
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
            users.${username} = {
              directories = [
                ".local/share/direnv"
              ];
            };
          };
        };

        home-manager.users.${username} = {
          pkgs,
          lib,
          config,
          ...
        }: {
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
