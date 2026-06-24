{...}: {
  flake = {
    nixosModules.username = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.user;
    in {
      options.custom.user = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "user";
          example = "nixi";
          description = "Username of the user to be created";
        };
        enable = lib.mkEnableOption "user";
        hashedPasswordFile = lib.mkOption {
          type = lib.types.path or null;
          default = null;
          example = config.sops.secrets."sudo_password/${hostname}".path;
          description = "Path to a file containing hashed password, created with `mkpasswd -m yescrypt`";
        };
        password = lib.mkOption {
          type = lib.types.str or null;
          default = null;
          example = "nixos";
          description = "string to be set as user password";
        };
        hashedPassword = lib.mkOption {
          type = lib.types.str or null;
          default = null;
          example = "$y$j9T$e3RBMYwLteags209/SMBP0$f4bZILjV/MjNCquJFQmxL55.q6SdtN.gbATDv7Mds50";
          description = "hashed string to be set as user password, created with `mkpasswd -m yescrypt`";
        };
      };

      config = lib.mkIf cfg.enable {
        users = {
          mutableUsers = false;
          groups.${cfg.name} = {
            gid = 1000;
          };
          users.${cfg.name} = {
            isNormalUser = true;
            uid = 1000;
            group = cfg.name;
            home = "/home/${cfg.name}";
            description = cfg.name;
            extraGroups = [
              "wheel"
              "networkmanager"
              "video"
              "audio"
              "render"
              "gamemode"
              "input"
            ];
            hashedPasswordFile = cfg.hashedPasswordFile;
            hashedPassword = cfg.hashedPassword;
            initialPassword = cfg.password;
            subUidRanges = [
              {
                startUid = 100000;
                count = 65536;
              }
            ];
            subGidRanges = [
              {
                startGid = 100000;
                count = 65536;
              }
            ];
            linger = true;
          };
        };
      };
    };
  };
}
