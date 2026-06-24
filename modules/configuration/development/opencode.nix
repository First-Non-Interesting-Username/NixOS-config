_: {
  flake = {
    nixosModules.opencode = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
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
