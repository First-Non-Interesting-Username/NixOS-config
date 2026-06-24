_: {
  flake = {
    nixosModules.opencode = {
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/opencode"
              ".local/share/opencode"
            ];
          };
        };
      };
      home-manager.users.${config.custom.user.name} = _: {
        programs = {
          opencode = {
            enable = true;
          };
        };
      };
    };
  };
}
