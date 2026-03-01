{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.nix = {
      pkgs,
      lib,
      config,
      ...
    }: {
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
            "https://hyprland.cachix.org"
            "https://attic.xuyh0120.win/lantian"
          ];

          trusted-public-keys = [
            "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "vicinae.cachix.org-1:1kDrfienkGHPYbkpNj1mWTr7Fm1+zcenzgTizIcI3oc="
            "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
            "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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

      system.stateVersion = "25.11";
      programs.nix-ld.enable = true;
    };
  };
}
