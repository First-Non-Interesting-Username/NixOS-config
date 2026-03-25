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
        impermanence,
        ...
      }:
      {
        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/sunshine"
            ];
          };
        };
        services.sunshine = {
          enable = true;
          autoStart = true;
          openFirewall = true;
          capSysAdmin = true;
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
