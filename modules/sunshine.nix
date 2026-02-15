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
    homeModules.moonlight = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        moonlight-qt
      ];
    };
  };
}
