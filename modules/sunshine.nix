{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.sunshine = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.sunshine = {
        enable = true;
        autoStart = true;
        openFirewall = true;
        capSysAdmin = true;
        # Port 47990
      };
    };
    nixosModules.moonlight = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        osConfig,
        ...
      }: {
        home.packages = with pkgs; [
          moonlight-qt
        ];
      };
    };
  };
}
