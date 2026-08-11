{
  pkgs,
  config,
  self,
  hostName,
  ...
}: {
  imports = [
    self.nixosModules.user
    self.nixosModules.hostname
    self.nixosModules.stylix
    self.nixosModules.preservation
    self.nixosModules.shell
  ];

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
      base16Scheme = "gruvbox-dark";
      icons = {
        package = pkgs.morewaita-icon-theme;
        name = "MoreWaita";
      };
    };
    preservation.enable = false;
    shell = {
      enable = true;
      name = "nushell";
    };
  };
}
