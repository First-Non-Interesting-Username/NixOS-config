_: {
  perSystem = _: {
    wrappers.packages.fastfetch = true;
  };

  flake.wrappers.fastfetch = {
    pkgs,
    wlib,
    ...
  }: {
    imports = [wlib.wrapperModules.fastfetch];
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
