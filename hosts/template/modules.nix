{
  pkgs,
  config,
  hostName,
  ...
}: {
  imports = [
    self.nixosModules.hostname
    # Import modules here
  ];

  custom = {
    hostname = hostName;
    # Configure modules here
  };
}
