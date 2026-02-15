{
  self,
  inputs,
  username,
  ...
}: {
  flake = {
    nixosModules.shell = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      users.users.${username}.shell = pkgs.zsh;
      programs.zsh.enable = true;
    };
    homeModules.shell = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs = {
        zsh = {
          enable = true;
          autocd = true;
          enableCompletion = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          dotDir = "${config.home.homeDirectory}/.config/zsh";
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
            if [[ $PWD == $HOME ]]; then
                cd ~/persist
            fi
            fastfetch
          '';
        };

        nix-index = {
          enable = true;
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

        btop.enable = true;

        bat.enable = true;

        fastfetch = {
          enable = true;
          settings = {
            display = {
              separator = "  ";
              color = "blue";
            };
            modules = [
              {
                type = "title";
                key = "";
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
                key = "";
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
                key = "";
              }
              {
                type = "gpu";
                key = "󰢮";
              }
              {
                type = "memory";
                key = "";
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
                key = "";
              }
              {
                type = "shell";
                key = "";
              }
              {
                type = "terminal";
                key = "";
              }
              {
                type = "packages";
                key = "󰏖";
              }
            ];
          };
        };
      };

      home.packages = with pkgs; [
        trash-cli
        ugrep
      ];

      home.shellAliases = {
        cat = "bat --style=plain --pager=never";
        igrep = "ug -t";
        rm = "trash-put";
        tp = "trash-put";
        tl = "trash-list";
        te = "trash-empty";
      };
    };
  };
}
