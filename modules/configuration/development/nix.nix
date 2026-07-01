{inputs, ...}: {
  flake = {
    nixosModules.nix = {
      lib,
      config,
      ...
    }: {
      environment.persistence = lib.mkIf config.custom.impermanence.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".cache/nix"
            ];
          };
        };
      };
      nix = {
        settings = {
          experimental-features = [
            "nix-command"
            "flakes"
            "pipe-operators"
          ];

          substituters = [
            "https://cache.nixos.org/"
            "https://nix-community.cachix.org/"
            "https://vicinae.cachix.org"
            "https://matrix.cachix.org"
            "https://devenv.cachix.org"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            "matrix.cachix.org-1:uZWavEIj0/oIRHPjh+OG586y4nXBlyI0xkYfZBfDx7w="
            "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          ];

          max-jobs = "auto";
          cores = 0;
          trusted-users = [
            "root"
            "@wheel"
          ];
        };
        channel.enable = false;
      };

      nixpkgs.config = {
        allowUnfree = true;
        allowBroken = false;
      };

      programs.nix-ld.enable = true;
    };
  };
}
