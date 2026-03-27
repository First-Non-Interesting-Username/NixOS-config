_: {
  flake = {
    nixosModules.update = {hostname, ...}: {
      programs.nh = {
        enable = true;
        clean = {
          dates = "daily";
          enable = true;
          extraArgs = "--keep-since 7d --keep 10 --gc";
        };
        flake = "github:First-Non-Interesting-Username/NixOS-config";
      };
      nix.optimise = {
        automatic = true;
        dates = "weekly";
      };
      system.autoUpgrade = {
        enable = true;
        flake = "github:First-Non-Interesting-Username/NixOS-config#${hostname}";
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
