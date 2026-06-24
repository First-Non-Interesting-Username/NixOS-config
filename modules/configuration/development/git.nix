_: {
  flake = {
    nixosModules.git = {
      pkgs,
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/git"
              ".config/gh"
            ];
          };
        };
      };

      programs.git.enable = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        git
        gh
      ];

      sops.secrets = {
        "github_pat" = {
          owner = config.custom.user.name;
        };
      };
      home-manager.users.${config.custom.user.name} = {
        pkgs,
        osConfig,
        ...
      }: {
        home.packages = with pkgs; [onefetch];
        programs = {
          git = {
            enable = true;
            settings = {
              user = {
                name = "First-Non-Interesting-Username";
                email = "janekmusin@proton.me";
              };
              push = {
                autoSetupRemote = true;
              };
              init.defaultBranch = "main";
              pull.rebase = true;
            };
          };
          gh = {
            enable = true;
            settings = {
              git_protocol = "ssh";
              prompt = "enabled";
            };
          };
        };

        programs.zsh.initContent = ''
          export GH_TOKEN="$(cat ${osConfig.sops.secrets.github_pat.path})"
        '';

        home.shellAliases = {
          commit = "git add . && git commit -m";
        };
      };
    };
    nixosModules.secretless-git = {
      pkgs,
      lib,
      config,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/git"
              ".config/gh"
            ];
          };
        };
      };

      programs.git.enable = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        git
        gh
      ];

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        home.packages = with pkgs; [onefetch];
        programs = {
          git = {
            enable = true;
            settings = {
              user = {
                name = "local";
                email = "local@local.local";
              };
              push = {
                autoSetupRemote = true;
              };
              init.defaultBranch = "main";
              pull.rebase = true;
            };
          };
          gh = {
            enable = true;
            settings = {
              git_protocol = "ssh";
              prompt = "enabled";
            };
          };
        };
        home.shellAliases = {
          commit = "git add . && git commit -m";
        };
      };
    };
  };
}
