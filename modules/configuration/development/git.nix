_: {
  flake = {
    nixosModules.git = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
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
        config,
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
              git_protocol = "https";
              prompt = "enabled";
            };
          };

          jujutsu = {
            enable = true;

            settings = {
              user = {
                name = "First-Non-Interesting-Username";
                email = "janekmusin@proton.me";

                git = {
                  push-bookmark-automatically = true;
                  default-branch = "main";
                };
              };
            };
          };
          zsh.initContent = lib.mkIf config.programs.zsh.enable ''
            export GH_TOKEN="$(cat ${osConfig.sops.secrets.github_pat.path})"
          '';
          nushell.extraEnv = lib.mkIf config.programs.nushell.enable ''
            $env.GH_TOKEN = (open ${osConfig.sops.secrets.github_pat.path} | str trim)
          '';
        };
      };
    };

    nixosModules.secretless-git = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
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
          jujutsu = {
            enable = true;
            settings = {
              user = {
                name = "local";
                email = "local@local.local";
              };

              git = {
                push-bookmark-automatically = true;
                default-branch = "main";
              };
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
      };
    };
  };
}
