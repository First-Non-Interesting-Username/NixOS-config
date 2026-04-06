_: let
  name = "btop";
in {
  perSystem = _: {
    wrappers.packages.${name} = true;
  };

  flake.wrappers.${name} = {wlib, ...}: {
    imports = [wlib.wrapperModules.${name}];
    settings = {
      color_theme = "gruvbox_dark";
      vim_keys = true;
    };
  };
}
