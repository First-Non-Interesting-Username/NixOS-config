{ inputs, ... }:
{
  flake = {
    nixosModules.vicinae =
      {
        lib,
        username,
        impermanence,
        ...
      }:
      {
        imports = lib.optionals impermanence [
          {
            environment.persistence."/persist" = {
              users.${username} = {
                directories = [
                  ".local/share/vicinae"
                  ".config/vicinae"
                ];
              };
            };
          }
        ];

        home-manager.users.${username} =
          {
            pkgs,
            lib,
            ...
          }:
          {
            imports = [
              inputs.vicinae.homeManagerModules.default
            ];
            services = {
              vicinae = {
                enable = true;
                systemd = {
                  enable = true;
                  autoStart = true;
                  environment = {
                    USE_LAYER_SHELL = 1;
                  };
                };
                settings = {
                  close_on_focus_loss = true;
                  consider_preedit = true;
                  pop_to_root_on_close = true;
                  favicon_service = "twenty";
                  search_files_in_root = true;
                  launcher_window = {
                    opacity = lib.mkForce 0.98;
                  };
                  theme = {
                    light = {
                      name = "stylix";
                    }; # Fallback if system switches
                    dark = {
                      name = "stylix";
                    }; # This is what you want for dark mode
                  };
                };
                extensions = with inputs.vicinae-extensions.packages.${pkgs.stdenv.hostPlatform.system}; [
                  bluetooth
                  nix
                  power-profile
                  vscode-recents
                  ssh
                  searxng
                  hypr-keybinds
                  it-tools
                ];
              };
            };
          };
      };
  };
}
