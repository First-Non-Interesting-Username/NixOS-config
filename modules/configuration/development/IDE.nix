_: {
  flake = {
    nixosModules.IDE = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/zed"
            ];
          };
        };
      };

      sops = {
        secrets.wakatime_api_key = {};
        templates.".wakatime.cfg" = {
          content = ''
            [settings]
            api_url = https://hackatime.hackclub.com/api/hackatime/v1
            api_key = ${config.sops.placeholder.wakatime_api_key}
            heartbeat_rate_limit_seconds = 30
          '';
          path = "${config.users.users.${config.custom.user.name}.home}/.wakatime.cfg";
          owner = config.custom.user.name;
          group = config.custom.user.name;
        };
      };

      home-manager.users.${config.custom.user.name} = {pkgs, ...}: {
        programs = {
          micro = {
            enable = true;
          };

          zed-editor = {
            enable = true;
            extensions = ["nix" "markdown-snippets" "marksman" "wakatime"];
            extraPackages = with pkgs; [
              nil
              alejandra
              marksman
            ];

            userSettings = {
              vim_mode = false;
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
            };
          };
        };

        home.packages = with pkgs; [
          nil
          alejandra
        ];

        home.sessionVariables = {
          EDITOR = "micro";
          VISUAL = "zededitor --wait";
        };
      };
    };
  };
}
