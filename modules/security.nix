{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.security = {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }: {
      security.polkit.enable = true;
    };
  };
}
