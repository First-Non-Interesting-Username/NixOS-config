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
      publicKey,
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
          ];
          openssh.authorizedKeys.keys = [publicKey];
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
        };
      };
      sops.secrets.sudo_password = {
        neededForUsers = true;
      };
    };
    homeModules.user = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
