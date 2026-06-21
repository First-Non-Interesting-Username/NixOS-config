_: {
  flake = {
    nixosModules.IDE = {
      lib,
      username,
      impermanence,
      config,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
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
          path = "${config.users.users.${username}.home}/.wakatime.cfg";
        };
      };

      home-manager.users.${username} = {pkgs, ...}: {
        home.file.".wakatime.cfg" = {
          text = ''            [settings]
                               api_url = https://hackatime.hackclub.com/api/hackatime/v1
                               api_key = e61ca5c1-4477-4390-b93a-d57be3a938f8
                               heartbeat_rate_limit_seconds = 30'';
        };
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
