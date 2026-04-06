_: let
  name = "fastfetch";
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
      display = {
        separator = "  ";
        color = "blue";
      };
      modules = [
        {
          type = "title";
          key = "";
          color = {
            user = "blue";
            at = "white";
            host = "blue";
          };
        }
        {
          type = "os";
          key = "󱄅";
        }
        {
          type = "kernel";
          key = "";
        }
        {
          type = "uptime";
          key = "󰅐";
        }
        "break"
        {
          type = "board";
          key = "󱩊";
        }
        {
          type = "cpu";
          key = "";
        }
        {
          type = "gpu";
          key = "󰢮";
        }
        {
          type = "memory";
          key = "";
          format = "{1} / {2}";
        }
        {
          type = "disk";
          key = "󰋊";
          format = "{1} / {2} ({9})";
        }
        {
          type = "display";
          key = "󰍹";
        }
        "break"
        {
          type = "de";
          key = "󰧨";
        }
        {
          type = "wm";
          key = "";
        }
        {
          type = "shell";
          key = "";
        }
        {
          type = "terminal";
          key = "";
        }
        {
          type = "packages";
          key = "󰏖";
        }
      ];
    };
  };
}
