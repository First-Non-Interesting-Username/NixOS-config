_: {
  flake = {
    nixosModules.nix = _: {
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
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            "matrix.cachix.org-1:uZWavEIj0/oIRHPjh+OG586y4nXBlyI0xkYfZBfDx7w="
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
