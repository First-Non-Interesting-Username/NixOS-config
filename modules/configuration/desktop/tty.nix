_: {
  flake = {
    nixosModules.tty = _: {
      services = {
        kmscon = {
          enable = true;
          config.hwaccel = true;
        };
        gpm = {
          enable = true;
          protocol = "imps2";
        };
      };
    };
  };
}
