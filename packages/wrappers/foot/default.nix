_: {
  perSystem = _: {
    wrappers.packages.foot = true;
  };

  flake.wrappers.foot = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.foot];

    extraPackages = [pkgs.nerd-fonts.jetbrains-mono];

    settings = {
      main = {
        include = "${pkgs.foot.themes}/share/foot/themes/gruvbox-dark";
        font = "JetBrainsMono Nerd Font:size=12";
      };
      csd = {
        size = 0;
      };
      scrollback = {
        multiplier = 5.0;
      };
      bell = {
        urgent = false;
        notify = false;
        visual = false;
      };
      cursor = {
        style = "beam";
        blink = true;
        blink-rate = 15000;
      };
    };
  };
}
