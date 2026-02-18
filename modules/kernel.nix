{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.kernel-minimal = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # System config goes here
    };
  };
}
