_: {
  flake = {
    nixosModules.nushell = {
      lib,
      pkgs,
      config,
      ...
    }: let
      cfg = config.custom.shell;
    in {
      config = lib.mkIf (cfg.enable
        && cfg.name
        == "nushell") {
        environment.persistence = lib.mkIf config.custom.impermanence.enable {
          "/persist" = {
            users.${config.custom.user.name} = {
              directories = [
                ".local/share/nushell"
                ".cache/nushell"
              ];
            };
          };
        };

        users.users.${config.custom.user.name}.shell = pkgs.nushell;
        environment.shells = [pkgs.nushell];

        home-manager.users.${config.custom.user.name} = _: {
          programs = {
            nushell = {
              enable = true;
              extraConfig = ''
                def copyfile [file: path] {
                  open $file | wl-copy
                }

                def copypath [] {
                  $env.PWD | wl-copy
                }
              '';
            };

            nix-index = {enableNushellIntegration = true;};
            starship = {enableNushellIntegration = true;};
            atuin = {enableNushellIntegration = true;};
            eza = {enableNushellIntegration = true;};
            zoxide = {enableNushellIntegration = true;};
            # tealdeer = {enableNushellIntegration = true;};
            television = {enableNushellIntegration = true;};
            pay-respects = {enableNushellIntegration = true;};
            yazi = {enableNushellIntegration = true;};
            nix-your-shell = {enableNushellIntegration = true;};
            broot = {enableNushellIntegration = true;};
            fzf = {enableNushellIntegration = true;};
            carapace = {enableNushellIntegration = true;};
          };
        };
      };
    };
  };
}
