{
  pkgs,
  self,
  hostName,
  ...
}: {
  imports = [self.nixosModules.user self.nixosModules.hostname self.nixosModules.stylix self.nixosModules.impermanence self.nixosModules.shell];

  custom = {
    user = {
      enable = true;
      name = "nixos";
      # password is `nixos`
      hashedPassword = "$y$j9T$e3RBMYwLteags209/SMBP0$f4bZILjV/MjNCquJFQmxL55.q6SdtN.gbATDv7Mds50";
    };
    hostname = hostName;
    stylix = {
      enable = true;
      image = {
        width = "1920";
        height = "1080";
      };
      base16Scheme = "gruvbox-dark";
      icons = {
        package = pkgs.morewaita-icon-theme;
        name = "MoreWaita";
      };
    };
    impermanence.enable = false;
    shell = {
      enable = true;
      name = "nushell";
    };
    DE = {
      enable = true;
      type = "gnome";
    };
  };
}
