{ self, ... }:
{
  flake = {
    nixosModules.opencode =
      {
        lib,
        username,
        impermanence,
        ...
      }:
      {
        imports =
          [ ]
          ++ lib.optional impermanence {
            environment.persistence."/persist" = {
              directories = [
                # System-level dirs to persist
              ];
              files = [
                # System-level files to persist
              ];
              users.${username} = {
                directories = [
                  # User-level dirs to persist (relative to $HOME)
                ];
                files = [
                  # User-level files to persist (relative to $HOME)
                ];
              };
            };
          };

        sops.secrets = {
          "LLM_keys/NVIDIA".owner = username;
          "LLM_keys/ZAI".owner = username;
          "LLM_keys/groq".owner = username;
          "LLM_keys/cerebras".owner = username;
          "LLM_keys/openrouter".owner = username;
          "LLM_keys/together".owner = username;
        };
        home-manager.users.${username} =
          { osConfig, pkgs, ... }:
          {
            imports = [
              self.homeModules.free-coding-models
            ];

            programs = {
              free-coding-models = {
                enable = true;
                nvidia-api-key-path = osConfig.sops.secrets."LLM_keys/NVIDIA".path;
                zai-api-key-path = osConfig.sops.secrets."LLM_keys/ZAI".path;
                groq-api-key-path = osConfig.sops.secrets."LLM_keys/groq".path;
                cerebras-api-key-path = osConfig.sops.secrets."LLM_keys/cerebras".path;
                openrouter-api-key-path = osConfig.sops.secrets."LLM_keys/openrouter".path;
                together-api-key-path = osConfig.sops.secrets."LLM_keys/together".path;
              };
            };
          };
      };
  };
}
