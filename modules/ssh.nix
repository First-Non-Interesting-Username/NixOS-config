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
      ...
    }: {
      programs.ssh.startAgent = true;
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
        extraConfig = ''
          Host Server
            HostName iameasytoremember.duckdns.org
            User nixi
            Port 6767
            IdentityFile ~/.ssh/id_ed25519
        '';
      };
    };
    nixosModules.ssh-minimal = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = true;
        };
      };
    };
    nixosModules.ssh-server = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.openssh = {
        enable = true;
        ports = [6767];
        settings = {
          PasswordAuthentication = false;
          PermitRootLogin = "no";
          KbdInteractiveAuthentication = false;
        };
      };

      services.fail2ban = {
        enable = true;
        jails.sshd = {
          settings = {
            enabled = true;
            port = "6767";
            filter = "sshd";
            maxretry = 5;
            bantime = "1h";
            findtime = "10m";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [6767];
    };
  };
}
