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
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJArhOHWLhh5bpFH3r1ANALhnkUek2o6hmHXsG61750V your_host_description"
          ];
          linger = true;
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
