{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.update = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs.nh = {
        enable = true;
        clean = {
          dates = "daily";
          enable = true;
          extraArgs = "--keep-since 7d --keep 10 --gc";
        };
        flake = "github:First-Non-Interesting-Username/NixOS-config#${config.networking.hostName}";
      };
      nix.optimise = {
        automatic = true;
        dates = "weekly";
      };
      system.autoUpgrade = {
        enable = true;
        flake = "github:First-Non-Interesting-Username/NixOS-config#${config.networking.hostName}";
        allowReboot = false;
        persistent = true;
        dates = "02:00";
        randomizedDelaySec = "45min";
        operation = "boot";
        flags = [
          "-L"
        ];
      };
    };
  };
}
