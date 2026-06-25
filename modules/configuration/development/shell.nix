{
  inputs,
  self,
  ...
}: {
  flake = {
    nixosModules.shell = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".local/share/atuin"
              ".local/share/zoxide"
              ".config/zsh"
              ".cache/tealdeer"
              ".local/share/nix-index"
            ];
          };
        };
      };

      users.users.${config.custom.user.name}.shell = pkgs.zsh;
      programs.zsh.enable = true;

      security.polkit.extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel")) {
            if (action.id.indexOf("org.nixos.") == 0 || action.id.indexOf("org.freedesktop.systemd1.") == 0) {
              return polkit.Result.AUTH_ADMIN_KEEP;
            }
          }
        });
      '';
      home-manager.users.${config.custom.user.name} = {
        pkgs,
        config,
        ...
      }: {
        imports = [
          inputs.nix-index-database.homeModules.nix-index
        ];
        programs = {
          zsh = {
            enable = true;
            autocd = true;
            enableCompletion = true;
            autosuggestion.enable = true;
            syntaxHighlighting.enable = true;
            dotDir = "${config.xdg.configHome}/zsh";
            oh-my-zsh = {
              enable = true;
              plugins = [
                "git"
                "copyfile"
                "copypath"
                "sudo"
              ];
              theme = "";
            };
            initContent = ''
              fastfetch
            '';
          };

          nix-index-database.comma.enable = true;
          nix-index = {
            enable = true;
            package = pkgs.nix-index;
            enableZshIntegration = true;
          };

          starship = {
            enable = true;
            enableZshIntegration = true;
          };

          atuin = {
            enable = true;
            enableZshIntegration = true;
          };

          eza = {
            enable = true;
            enableZshIntegration = true;
            icons = "auto";
            git = true;
          };

          zoxide = {
            enable = true;
            enableZshIntegration = true;
          };

          tealdeer = {
            enable = true;
            enableAutoUpdates = true;
          };

          television = {
            enable = true;
            enableZshIntegration = true;
          };

          pay-respects = {
            enable = true;
            enableZshIntegration = true;
          };

          lazygit = {
            enable = true;
            enableZshIntegration = true;
          };

          bat.enable = true;

          fd.enable = true;

          btop = {
            enable = true;
            settings = {vim_keys = true;};
          };

          fastfetch = {
            enable = true;
            settings = {
              display = {
                separator = "  ";
                color = "blue";
              };
              modules = [
                {
                  type = "title";
                  key = "";
                  color = {
                    user = "blue";
                    at = "white";
                    host = "blue";
                  };
                }
                {
                  type = "os";
                  key = "󱄅";
                }
                {
                  type = "kernel";
                  key = "";
                }
                {
                  type = "uptime";
                  key = "󰅐";
                }
                "break"
                {
                  type = "board";
                  key = "󱩊";
                }
                {
                  type = "cpu";
                  key = "";
                }
                {
                  type = "gpu";
                  key = "󰢮";
                }
                {
                  type = "memory";
                  key = "";
                  format = "{1} / {2}";
                }
                {
                  type = "disk";
                  key = "󰋊";
                  format = "{1} / {2} ({9})";
                }
                {
                  type = "display";
                  key = "󰍹";
                }
                "break"
                {
                  type = "de";
                  key = "󰧨";
                }
                {
                  type = "wm";
                  key = "";
                }
                {
                  type = "shell";
                  key = "";
                }
                {
                  type = "terminal";
                  key = "";
                }
                {
                  type = "packages";
                  key = "󰏖";
                }
              ];
            };
          };

          yazi = {
            enable = true;
            enableZshIntegration = true;
          };
          nix-your-shell = {
            enable = true;
            enableZshIntegration = true;
          };
          broot = {
            enable = true;
            enableZshIntegration = true;
          };
          fzf = {
            enable = true;
            enableZshIntegration = true;
          };
          carapace = {
            enable = true;
            enableZshIntegration = true;
          };
        };

        home = {
          packages = with pkgs; [
            trash-cli
            ugrep
            ripgrep
            shell-gpt
            devenv
          ];
          shellAliases = {
            cat = "bat --style=plain --pager=never";
            igrep = "ug -Q";
            tp = "trash-put";
            tl = "trash-list";
            te = "trash-empty";
            bin = "nc termbin.com 9999";
          };
        };
      };
    };
  };
}
