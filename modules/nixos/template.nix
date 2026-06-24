{...}: {
  flake = {
    nixosModules.CHANGEME = {...}: {
      options.custom.CHANGEME = {
        # Create options here
      };

      config = {
        # Add config here
      };
    };
  };
}
