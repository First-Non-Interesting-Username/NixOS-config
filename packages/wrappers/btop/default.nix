_: let
  name = "btop";
in {
  perSystem = _: {
    wrappers.packages.${name} = true;
  };

  flake.wrappers.${name} = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.${name}];
    settings = {
      color_theme = "gruvbox_dark";
      vim_keys = true;
    };
  };
}
