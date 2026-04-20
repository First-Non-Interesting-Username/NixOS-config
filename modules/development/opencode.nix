{self, ...}: {
  flake = {
    nixosModules.opencode = {
      lib,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".config/opencode"
              ".local/share/opencode"
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
      home-manager.users.${username} = {osConfig, ...}: {
        imports = [
        ];

        programs = {
          opencode = {
            enable = true;
          };
        };
      };
    };
  };
}
