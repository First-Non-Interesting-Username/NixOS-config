{...}: {
  flake = {
    nixosModules.modules = {
      lib,
      pkgs,
      config,
      ...
    }: {
      imports = [];
    };
  };
}
