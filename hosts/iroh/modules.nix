{
  pkgs,
  hostname,
  config,
  self,
  ...
}: {
  imports = [self.nixosModules.user];
  sops.secrets."sudo_password/${hostname}" = {
    neededForUsers = true;
  };

  custom.user = {
    enable = true;
    name = "nixi";
    hashedPasswordFile = config.sops.secrets."sudo_password/${hostname}".path;
  };
}
