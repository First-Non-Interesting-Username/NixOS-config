{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.ssh =
      {
        pkgs,
        lib,
        config,
        username,
        ...
      }:
      {
        programs.ssh.startAgent = true;
        systemd.tmpfiles.rules = [
          "d /home/${username}/.ssh 0700 ${username} users - -"
        ];
      };
    homeModules.ssh =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
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
    nixosModules.ssh-minimal =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        services.openssh = {
          enable = true;
          settings = {
            PermitRootLogin = "yes";
            PasswordAuthentication = true;
          };
        };
      };
  };
}
