{...}: {
  flake = {
    nixosModules.CHANGEME = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.CHANGEME;
    in {
      options.custom.CHANGEME = {
        # Create options here
      };

      config = {
        # Add config here
      };
    };
  };
}
