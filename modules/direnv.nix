{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.direnv = {
      pkgs,
      lib,
      config,
      options,
      username,
      ...
    }: {
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
