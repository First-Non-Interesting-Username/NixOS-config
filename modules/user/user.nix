_: {
  flake = {
    nixosModules.user =
      {
        lib,
        config,
        username,
        hostname,
        impermanence,
        ...
      }:
      {
        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/AccountsService"
            ];
          };
        };
        users = {
          mutableUsers = false;
          groups.${username} = {
            gid = 1000;
          };
          users.${username} = {
            isNormalUser = true;
            uid = 1000;
            group = username;
            home = "/home/${username}";
            description = username;
            extraGroups = [
              "wheel"
              "networkmanager"
              "video"
              "audio"
              "render"
              "gamemode"
              "input"
            ];
            hashedPasswordFile = config.sops.secrets."sudo_password/${hostname}".path;
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
        sops.secrets."sudo_password/${hostname}" = {
          neededForUsers = true;
        };
      };
    nixosModules.secretless-user =
      {
        lib,
        config,
        username,
        hostname,
        impermanence,
        ...
      }:
      {
        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = [
              "/var/lib/AccountsService"
            ];
          };
        };
        users = {
          mutableUsers = false;
          groups.${username} = {
            gid = 1000;
          };
          users.${username} = {
            isNormalUser = true;
            uid = 1000;
            group = username;
            home = "/home/${username}";
            description = username;
            extraGroups = [
              "wheel"
              "networkmanager"
              "video"
              "audio"
              "render"
              "gamemode"
              "input"
            ];
            # password is `1234`
            hashedPassword = "$y$j9T$ZsgrMRgvApvOV20RDbqB/1$DFNUwdqXzkAKADHKlgxx0zNwenuh8162XSPfzFu7Nf7";
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
    nixosModules.user-debug = _: {
      users.users.root.initialPassword = "debug";
    };
  };
}
