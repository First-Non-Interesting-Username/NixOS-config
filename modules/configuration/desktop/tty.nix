{...}: {
  flake = {
    nixosModules.tty = {
      lib,
      config,
      ...
    }: {
      services.kmscon = {
          enable = true;
          hwRender = true;
        };
    };
  };
}
