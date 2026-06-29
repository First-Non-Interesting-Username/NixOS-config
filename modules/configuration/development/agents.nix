{inputs, ...}: {
  flake = {
    nixosModules.agents = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/opencode"
              ".local/share/opencode"
            ];
          };
        };
      };

      nix.settings = {
        extra-substituters = [ "https://cache.numtide.com" ];
        extra-trusted-public-keys = [
          "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
        ];
      };

      home-manager.users.${config.custom.user.name} = _: {
        programs = {
          opencode = {
            package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
            enable = true;
          };
        };
      };
    };
  };
}
