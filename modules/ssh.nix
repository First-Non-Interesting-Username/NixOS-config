{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.ssh = {
      pkgs,
      lib,
      config,
      username,
      publicKey,
      ...
    }: {
      sops.secrets.ssh_private_key = {
        path = "/home/${username}/.ssh/id_ed25519";
        owner = username;
        mode = "0600";
      };
      programs.ssh.startAgent = true;
      users.users.${username}.openssh.authorizedKeys.keys = [publicKey];
      systemd.tmpfiles.rules = [
        "d /home/${username}/.ssh 0700 ${username} users - -"
      ];
    };
    homeModules.ssh = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.packages = with pkgs; [
        lazyssh
      ];
      programs.ssh = {
        enable = true;
        matchBlocks."*".addKeysToAgent = "yes";
        enableDefaultConfig = false;
        matchBlocks."*" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  };
}
