{hostName, ...}: {
  imports = [
    self.nixosModules.hostname
    self.nixosModules.preservation
    # Import modules here
  ];

  custom = {
    hostname = hostName;
    preservation.enable = false; # or true, without that things will break
    # Configure modules here
  };
}
