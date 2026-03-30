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

      extraPackages = [ pkgs.nerd-fonts.jetbrains-mono ];

      settings = {
        main = {
          include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";

          font = "JetBrainsMono Nerd Font:size=12";
        };

        colors = {
        };
      };
    };
}
