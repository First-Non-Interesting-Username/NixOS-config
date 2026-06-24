{
  pkgs,
  config,
  self,
  hostName,
  ...
}: {
  imports = [self.nixosModules.user self.nixosModules.hostname self.nixosModules.stylix self.nixosModules.impermanence];
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
    stylix = {
      enable = true;
      image = {
        width = "2256";
        height = "1504";
      };
      base16Scheme = "gruvbox-dark";
      icons = {
        package = pkgs.morewaita-icon-theme;
        name = "MoreWaita";
      };
    };
    impermanence.enable = true;
  };
}
