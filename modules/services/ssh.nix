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
      impermanence,
      ...
    }: let
      sshDir =
        if impermanence
        then "/persist"
        else "";
    in {
      programs.ssh.startAgent = true;
      systemd.tmpfiles.rules = [
        "d ${config.users.users.${username}.home}/.ssh 0700 ${username} users - -"
      ];
      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGzRUdlC8OdgeZhL9Kn+57GHAmMpkfBG3iqPl3dRYTM Desktop_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFb1ByQK+SH7b7ZD+Epe5zYDyOUp2V0Sr/GcAfKy8J4y Laptop_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhyyqVG8KdfHL00jBin/8rJzaD1Str3lO7N+IeF8fPI Server_key"
        ];
      };
      sops.secrets."ssh_keys/private/${hostname}" = {
        owner = username;
        group = config.users.users.${username}.group;
        mode = "0600";
        path = "${sshDir}${config.users.users.${username}.home}/.ssh/id_ed25519";
      };
      sops.secrets."ssh_keys/public/${hostname}" = {
        owner = username;
        group = config.users.users.${username}.group;
        mode = "0644";
        path = "${sshDir}${config.users.users.${username}.home}/.ssh/id_ed25519.pub";
      };

      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              {
                directory = ".ssh";
                mode = "0700";
              }
            ];
          };
        };
      };

      home-manager.users.${username} = {
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
          enableDefaultConfig = false;
          matchBlocks."*" = {
            identityFile = "~/.ssh/id_ed25519";
            addKeysToAgent = "yes";
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
    };

    nixosModules.ssh-debug = {
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
    }: let
      sshPort = 6767;
    in {
      services.openssh = {
        enable = true;
        ports = [sshPort];
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
            port = toString sshPort;
            filter = "sshd";
            maxretry = 5;
            bantime = "1h";
            findtime = "10m";
          };
        };
      };

      networking.firewall.allowedTCPPorts = [sshPort];
    };
  };
}
