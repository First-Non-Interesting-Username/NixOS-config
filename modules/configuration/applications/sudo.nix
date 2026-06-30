{...}: {
  flake = {
    nixosModules.sudo = {
      lib,
      config,
      ...
    }: {
      security = {
        sudo.enable = false;
        sudo-rs.enable = true;
      };
    };
  };
}
