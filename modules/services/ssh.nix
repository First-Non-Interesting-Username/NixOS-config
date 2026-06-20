_: {
  flake = {
    nixosModules.ssh = {
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
        inherit (config.users.users.${username}) group;
        mode = "0600";
        path = "${sshDir}${config.users.users.${username}.home}/.ssh/id_ed25519";
      };
      sops.secrets."ssh_keys/public/${hostname}" = {
        owner = username;
        inherit (config.users.users.${username}) group;
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

      home-manager.users.${username} = _: {
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          settings = {
            "*" = {
              IdentityFile = "~/.ssh/id_ed25519";
              AddKeysToAgent = "yes";
              IdentitiesOnly = "yes";
              ServerAliveInterval = "60";
              ServerAliveCountMax = "3";
              ConnectTimeout = "10";

              ForwardX11 = "no";
              ForwardX11Trusted = "no";
              PasswordAuthentication = "yes";
              VisualHostKey = "yes";
            };
            "Iroh" = {
              HostName = "iameasytoremember.duckdns.org";
              User = "nixi";
              Port = 6767;
              IdentityFile = "~/.ssh/id_ed25519";
            };
          };
        };
      };
    };

    nixosModules.secretless-ssh = {
      lib,
      config,
      username,
      impermanence,
      ...
    }: let
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILh2Ni5c9wMmg1ojjGmlf0oPuijIYVQhV8kLX3nSoP4v Showcase_keys";
      privateKey = ''
        -----BEGIN OPENSSH PRIVATE KEY-----
        b3BlbnNzaC1rZXktdjEAAAAABG5vbmUAAAAEbm9uZQAAAAAAAAABAAAAMwAAAAtzc2gtZW
        QyNTUxOQAAACC4djYuXPcDJoNaI4xppX9KD7ooyGFUIVfJC1950qD+LwAAAJAQ6ZXrEOmV
        6wAAAAtzc2gtZWQyNTUxOQAAACC4djYuXPcDJoNaI4xppX9KD7ooyGFUIVfJC1950qD+Lw
        AAAEDwlgVBitg7jIrkgRl7bdA7c1AuY+/JFbmIfdo+Xa8PxLh2Ni5c9wMmg1ojjGmlf0oP
        uijIYVQhV8kLX3nSoP4vAAAADVNob3djYXNlX2tleXM=
        -----END OPENSSH PRIVATE KEY-----
      '';
    in {
      programs.ssh.startAgent = true;
      systemd.tmpfiles.rules = [
        "d ${config.users.users.${username}.home}/.ssh 0700 ${username} users - -"
        "f ${config.users.users.${username}.home}/.ssh/id_* 0600 ${username} users - -"
        "f ${config.users.users.${username}.home}/.ssh/*.pub 0644 ${username} users - -"
        "f ${config.users.users.${username}.home}/.ssh/authorized_keys 0644 ${username} users - -"
      ];
      users.users.${username} = {
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPGzRUdlC8OdgeZhL9Kn+57GHAmMpkfBG3iqPl3dRYTM Desktop_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFb1ByQK+SH7b7ZD+Epe5zYDyOUp2V0Sr/GcAfKy8J4y Laptop_key"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPhyyqVG8KdfHL00jBin/8rJzaD1Str3lO7N+IeF8fPI Server_key"
        ];
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

      home-manager.users.${username} = {pkgs, ...}: {
        home.packages = with pkgs; [
          lazyssh
        ];
        home.file = {
          ".ssh/id_ed25519" = {
            text = privateKey;
          };
          ".ssh/id_ed25519.pub" = {
            text = publicKey;
          };
        };
        programs.ssh = {
          enable = true;
          enableDefaultConfig = false;
          settings = {
            "*" = {
              IdentityFile = "~/.ssh/id_ed25519";
              AddKeysToAgent = "yes";
            };
            "Host Server" = {
              HostName = "iameasytoremember.duckdns.org";
              User = "nixi";
              Port = 6767;
              IdentityFile = "~/.ssh/id_ed25519";
            };
          };
        };
      };
    };

    nixosModules.ssh-debug = _: {
      services.openssh = {
        enable = true;
        settings = {
          PermitRootLogin = "yes";
          PasswordAuthentication = true;
        };
      };
    };
    nixosModules.ssh-server = _: let
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
        hostKeys = [
          {
            path = "/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
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
