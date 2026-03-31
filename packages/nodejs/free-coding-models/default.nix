{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages = {
      free-coding-models = pkgs.callPackage ./_package.nix {};
    };
  };

  flake = {
    homeModules.free-coding-models = {
      config,
      lib,
      pkgs,
      ...
    }: let
      cfg = config.programs.free-coding-models;
      mkApiKeyOption = serviceName:
        lib.mkOption {
          type = lib.types.nullOr lib.types.path;
          default = null;
          description = "API key for ${serviceName} API for LLMs";
          example = "osConfig.sops.secrets.${lib.toUpper serviceName}_API_KEY.path";
        };
      providers = [
        "nvidia"
        "iflow"
        "zai"
        "dashscope"
        "groq"
        "cerebras"
        "sambanova"
        "openrouter"
        "huggingface"
        "together"
        "deepinfra"
        "fireworks"
        "codestral"
        "hyperbolic"
        "scaleway"
        "google"
        "siliconflow"
        "perplexity"
        "replicate"
      ];
    in {
      options.programs.free-coding-models = lib.mkOption {
        default = {};
        type = lib.types.submodule {
          options =
            lib.listToAttrs (
              map (name: {
                name = "${name}-api-key-path";
                value = mkApiKeyOption name;
              })
              providers
            )
            // {
              enable = lib.mkEnableOption "free-coding-models";
              cloudflare = lib.mkOption {
                default = {};
                type = lib.types.submodule {
                  options = {
                    api-token-path = lib.mkOption {
                      type = lib.types.nullOr lib.types.path;
                      default = null;
                      description = "API token for CLOUDFLARE API";
                      example = "osConfig.sops.secrets.CLOUDFLARE_API_TOKEN.path";
                    };
                    account-id-path = lib.mkOption {
                      type = lib.types.nullOr lib.types.path;
                      default = null;
                      description = "Account ID for CLOUDFLARE";
                      example = "osConfig.sops.secrets.CLOUDFLARE_ACCOUNT_ID.path";
                    };
                  };
                };
              };
            };
        };
      };

      config = lib.mkIf cfg.enable {
        home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.free-coding-models];

        programs.bash.initExtra =
          lib.concatMapStrings (
            name:
              lib.optionalString (cfg."${name}-api-key-path" != null) ''
                export ${lib.toUpper (lib.replaceStrings ["-"] ["_"] name)}_API_KEY=$(cat ${
                  toString cfg."${name}-api-key-path"
                })
              ''
          )
          providers
          + lib.optionalString (cfg.cloudflare.api-token-path != null) ''
            export CLOUDFLARE_API_TOKEN=$(cat ${toString cfg.cloudflare.api-token-path})
          ''
          + lib.optionalString (cfg.cloudflare.account-id-path != null) ''
            export CLOUDFLARE_ACCOUNT_ID=$(cat ${toString cfg.cloudflare.account-id-path})
          '';
      };
    };
  };
}
