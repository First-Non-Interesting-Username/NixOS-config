{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.sunshine =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        services.sunshine = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          capSysAdmin = true;
          # Port 47990
        };

        services.udev.extraRules = ''
          KERNEL=="uinput", MODE="0660", GROUP="input", SYMLINK+="uinput"
        '';

        boot.kernelModules = [ "uinput" ];
      };
    nixosModules.moonlight =
      {
        pkgs,
        lib,
        config,
        username,
        ...
      }:
      {
        home-manager.users.${username} =
          {
            pkgs,
            lib,
            config,
            osConfig,
            ...
          }:
          {
            home.packages = with pkgs; [
              moonlight-qt
            ];
          };
      };
  };
}
