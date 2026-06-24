_: {
  flake = {
    nixosModules.sunshine = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
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

      boot.kernelModules = ["uinput"];
    };
    nixosModules.moonlight = {config, ...}: {
      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        home.packages = with pkgs; [
          moonlight-qt
        ];
      };
    };
  };
}
