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
        flake = inputs.self.outPath;
      };
      nix.optimise = {
        automatic = true;
        dates = "weekly";
      };
      system.autoUpgrade = {
        enable = true;
        flake = inputs.self.outPath;
        allowReboot = false;
        persistent = true;
        dates = "02:00";
        randomizedDelaySec = "45min";
        operation = "boot";
        flags = [
          "--print-build-logs"
          "-L"
        ];
      };
    };
  };
}
