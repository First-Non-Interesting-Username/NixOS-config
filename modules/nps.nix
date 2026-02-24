{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.nps =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        # TBD
      };
    homeModules.nps =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {

      };
  };
}
