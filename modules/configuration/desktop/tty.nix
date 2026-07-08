{...}: {
  flake = {
    nixosModules.tty = {
      lib,
      config,
      ...
    }: {
      services.kmscon = {
        enable = true;
        config.hwaccel = true;
      };
    };
  };
}
