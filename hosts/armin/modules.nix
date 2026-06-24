{
  pkgs,
  config,
  self,
  hostName,
  ...
}: {
  imports = [self.nixosModules.user self.nixosModules.hostname];
  sops.secrets."sudo_password/${config.custom.hostname}" = {
    neededForUsers = true;
  };

  custom = {
    user = {
      enable = true;
      name = "nixi";
      hashedPasswordFile = config.sops.secrets."sudo_password/${config.custom.hostname}".path;
    };
    hostname = hostName;
  };
}
