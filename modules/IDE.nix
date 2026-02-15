{
  self,
  inputs,
  ...
}: {
  flake = {
    homeModules.IDE = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs = {
        vscode = {
          enable = true;
          package = pkgs.vscodium;
          profiles.default = {
            extensions = with pkgs.vscode-extensions; [
              jnoortheen.nix-ide
              wakatime.vscode-wakatime
            ];
            userSettings = {
              "nix.enableLanguageServer" = true;
              "nix.serverPath" = "nil";
              "nix.formatterPath" = "alejandra";
              "editor.formatOnSave" = true;
              "workbench.editor.defaultBinaryEditor" = "hexEditor.treeview";
            };
          };
        };

        micro = {
          enable = true;
        };

        zed-editor = {
          enable = true;
          extensions = ["nix"];
          extraPackages = with pkgs; [
            nil
            alejandra
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
          # No bars
          # Dark mode for everything
        };
      };

      home.packages = with pkgs; [
        nil
        alejandra
      ];

      home.sessionVariables = {
        EDITOR = "codium --wait";
        VISUAL = "codium --wait";
      };
    };
  };
}
