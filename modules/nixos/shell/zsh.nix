{...}: {
  flake = {
    nixosModules.zsh = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.shell;
    in {
      config = lib.mkIf (cfg.enable
        && cfg.name
        == "zsh") {
        environment.persistence = lib.mkIf config.custom.impermanence.enable {
          "/persist" = {
            users.${config.custom.user.name} = {
              directories = [
                ".config/zsh"
              ];
            };
          };
        };

        users.users.${config.custom.user.name}.shell = pkgs.zsh;
        programs.zsh.enable = true;

        home-manager.users.${config.custom.user.name} = {
          pkgs,
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

            nix-index = {enableZshIntegration = true;};
            starship = {enableZshIntegration = true;};
            atuin = {enableZshIntegration = true;};
            eza = {enableZshIntegration = true;};
            zoxide = {enableZshIntegration = true;};
            tealdeer = {enableZshIntegration = true;};
            television = {enableZshIntegration = true;};
            pay-respects = {enableZshIntegration = true;};
            yazi = {enableZshIntegration = true;};
            nix-your-shell = {enableZshIntegration = true;};
            broot = {enableZshIntegration = true;};
            fzf = {enableZshIntegration = true;};
            carapace = {enableZshIntegration = true;};
          };
        };
      };
    };
  };
}
