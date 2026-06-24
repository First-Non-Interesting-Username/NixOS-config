_: {
  flake = {
    nixosModules.opencode = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".config/opencode"
              ".local/share/opencode"
            ];
          };
        };
      };
      home-manager.users.${username} = _: {
        programs = {
          opencode = {
            enable = true;
          };
        };
      };
    };
  };
}
