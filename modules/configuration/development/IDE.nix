_: {
  flake = {
    nixosModules.IDE = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".config/zed"
            ];
            files = [
              ".wakatime.cfg"
            ];
          };
        };
      };

      home-manager.users.${username} = {pkgs, ...}: {
        programs = {
          micro = {
            enable = true;
          };

          zed-editor = {
            enable = true;
            extensions = ["nix" "markdown-snippets" "marksman"];
            extraPackages = with pkgs; [
              nil
              alejandra
              marksman
            ];

            userSettings = {
              lsp = {
                nil = {
                  initialization_options = {
                    formatting = {
                      command = ["alejandra"];
                    };
                  };
                };
              };

              languages = {
                Markdown = {
                  format_on_save = "on";
                  formatter = "prettier";
                  prettier = {
                    allowed = true;
                  };
                };

                Nix = {
                  language_servers = [
                    "nil"
                    "!nixd"
                  ];
                  formatter = {
                    external = {
                      command = "alejandra";
                      arguments = [
                        "--quiet"
                        "--"
                      ];
                    };
                  };
                };
              };

              format_on_save = "on";
              vim_mode = true;
            };
          };
        };

        home.packages = with pkgs; [
          nil
          alejandra
        ];

        home.sessionVariables = {
          EDITOR = "zed --wait";
          VISUAL = "zed --wait";
        };
      };
    };
  };
}
