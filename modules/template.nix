{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.CHANGEME = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # System config goes here
    };
    homeModules.CHANGEME = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
