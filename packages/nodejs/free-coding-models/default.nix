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
      options.programs.free-coding-models =
        lib.listToAttrs (
          map (name: {
            name = "${name}-api-key-path";
            value = mkApiKeyOption name;
          })
          providers
        )
        // {
          enable = lib.mkEnableOption "free-coding-models";
          cloudflare = {
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

      config = lib.mkIf cfg.enable {
        home.packages = [self.packages.${pkgs.stdenv.hostPlatform.system}.free-coding-models];

        home.sessionVariables =
          lib.foldl' (
            acc: name:
              acc
              // lib.optionalAttrs (cfg."${name}-api-key-path" != null) {
                "${lib.toUpper (lib.replaceStrings ["-"] ["_"] name)}_API_KEY" =
                  builtins.readFile
                  cfg."${name}-api-key-path";
              }
          ) {}
          providers
          // lib.optionalAttrs (cfg.cloudflare.api-token-path != null) {
            CLOUDFLARE_API_TOKEN = builtins.readFile cfg.cloudflare.api-token-path;
          }
          // lib.optionalAttrs (cfg.cloudflare.account-id-path != null) {
            CLOUDFLARE_ACCOUNT_ID = builtins.readFile cfg.cloudflare.account-id-path;
          }
          // lib.optionalAttrs (cfg.replicate-api-key-path != null) {
            REPLICATE_API_TOKEN = builtins.readFile cfg.replicate-api-key-path;
          };
      };
    };
  };
}
