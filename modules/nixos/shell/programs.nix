{inputs, ...}: {
  flake = {
    nixosModules.shell-programs = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.shell;
      shell =
        if cfg.name == "nushell"
        then "Nushell"
        else if cfg.name == "zsh"
        then "Zsh"
        else null;
    in {
      imports = [
        inputs.nix-index-database.homeModules.nix-index
      ];
      config = lib.mkIf cfg.enable {
        environment.persistence = lib.mkIf config.custom.impermanence.enable {
          "/persist" = {
            users.${config.custom.user.name} = {
              directories = [
                ".local/share/atuin"
                ".local/share/zoxide"
                ".cache/tealdeer"
                ".local/share/nix-index"
                ".local/share/yazi"
                ".local/share/broot"
                ".cache/yazi"
                ".cache/carapace"
                ".config/carapace"
              ];
            };
          };
        };

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
            nix-index-database.comma = {enable = true;};
            nix-index = {
              enable = true;
              package = pkgs.nix-index;
            };

            starship = {
              enable = true;
            };

            atuin = {
              enable = true;
            };

            eza = {
              enable = true;
              icons = "auto";
              git = true;
            };

            zoxide = {
              enable = true;
            };

            tealdeer = {
              enable = true;
              settings.updates.auto_update = true;
            };

            television = {
              enable = true;
            };

            pay-respects = {
              enable = true;
            };

            bat = {enable = true;};

            fd = {enable = true;};

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
            };
            nix-your-shell = {
              enable = true;
            };
            broot = {
              enable = true;
            };
            fzf = {
              enable = true;
            };
            carapace = {
              enable = true;
            };
            ripgrep = {
              enable = true;
            };
          };
          home = {
            packages = with pkgs; [
              ugrep
              devenv
            ];
            shellAliases = {
              cat = "bat --style=plain --pager=never";
              igrep = "ug -Q";
              te = "trash-empty";
              tb = "nc termbin.com 9999";
            };
          };
        };
      };
    };
  };
}
