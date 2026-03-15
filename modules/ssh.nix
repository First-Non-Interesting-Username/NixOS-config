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
      hostname,
      ...
    }: {
      programs.ssh.startAgent = true;
      systemd.tmpfiles.rules = [
        "d /home/${username}/.ssh 0700 ${username} users - -"
      ];
      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFb1ByQK+SH7b7ZD+Epe5zYDyOUp2V0Sr/GcAfKy8J4y Laptop_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhyyqVG8KdfHL00jBin/8rJzaD1Str3lO7N+IeF8fPI Server_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGzRUdlC8OdgeZhL9Kn+57GHAmMpkfBG3iqPl3dRYTM Desktop_key"
        ];
      };
      sops.secrets."private_ssh_key/${hostname}" = {
        owner = username;
        group = config.users.users.${username}.group;
        mode = "0600";
        path = "${config.users.users.${username}.home}/.ssh/id_ed25519";
      };
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
