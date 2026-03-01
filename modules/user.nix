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
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzvlSX1D6PI5Oie/fCOKnPpvgfMuHzPKV9E11T8Fa2/ server_keys"
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAuo3+HnTJrvgzxtPczw8j1zicwVjSbH7+b0KO7xLu+f desktop_keys"
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
