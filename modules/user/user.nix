{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.user = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      users = {
        mutableUsers = false;
        users.${username} = {
          isNormalUser = true;
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
          hashedPasswordFile = config.sops.secrets.sudo_password.path;
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
      sops.secrets.sudo_password = {
        neededForUsers = true;
      };
    };
    nixosModules.user-debug = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      users.users.root.initialPassword = "debug";
    };
  };
}
