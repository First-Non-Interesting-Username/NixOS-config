{
  inputs,
  self,
  ...
}:
{
  flake = {
    nixosModules.shell =
      {
        pkgs,
        lib,
        username,
        impermanence,
        ...
      }:
      {
        imports = lib.optional impermanence {
          environment.persistence."/persist" = {
            users.${username} = {
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

        users.users.${username}.shell = pkgs.zsh;
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
        home-manager.users.${username} =
          {
            pkgs,
            config,
            ...
          }:
          {
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
            };

            home = {
              packages = with pkgs; [
                trash-cli
                ugrep
                ripgrep
                self.packages.${pkgs.stdenv.hostPlatform.system}.fastfetch
                self.packages.${pkgs.stdenv.hostPlatform.system}.btop
                shell-gpt
              ];
              shellAliases = {
                cat = "bat --style=plain --pager=never";
                igrep = "ug -t";
                rm = "trash-put";
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
