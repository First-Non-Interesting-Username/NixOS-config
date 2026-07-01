_: {
  flake = {
    nixosModules.update = {
      pkgs,
      config,
      ...
    }: let
      flakeRef = "github:First-Non-Interesting-Username/NixOS-config/main#${config.custom.hostname}";
    in {
      programs.nh = {
        enable = true;
        clean = {
          dates = "daily";
          enable = true;
          extraArgs = "--keep-since 7d --keep 10";
        };
        flake = flakeRef;
      };
      environment.variables = {
        NH_OS_FLAKE = flakeRef;
      };
      nix = {
        optimise = {
          automatic = true;
          dates = "weekly";
        };
      };
      systemd = {
        services.nixos-upgrade = {
          description = "NixOS upgrade";
          requires = ["network-online.target"];
          after = ["network-online.target"];

          serviceConfig = {
            Type = "oneshot";
            ExecStart = pkgs.writeShellScript "upgrade" ''
              set -e
              ${pkgs.nixos-rebuild}/bin/nixos-rebuild boot \
                --flake flakeRef \
                -L
            '';
          };
        };

        timers.nixos-upgrade = {
          description = "Run upgrade daily";
          wantedBy = ["timers.target"];
          timerConfig = {
            OnCalendar = "02:00";
            RandomizedDelaySec = "45min";
            Persistent = true;
          };
        };
      };
    };
  };
}
