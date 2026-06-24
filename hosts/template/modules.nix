{
  pkgs,
  config,
  hostName,
  ...
}: {
  imports = [
    self.nixosModules.hostname
    self.nixosModules.impermanence
    # Import modules here
  ];

  custom = {
    hostname = hostName;
    impermanence.enable = false; # or true, without that things will break
    # Configure modules here
  };
}
