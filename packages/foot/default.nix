{ ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      wrappers.pkgs = pkgs;
      wrappers.packages.foot = true;
      wrappers.control_type = "build";
    };

  flake.wrappers.foot =
    {
      pkgs,
      wlib,
      ...
    }:
    {
      imports = [ wlib.wrapperModules.foot ];

      settings = {
      };
    };
}
