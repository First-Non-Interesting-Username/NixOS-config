{inputs, ...}: {
  flake = {
    nixosModules.vlh-agent = {
      lib,
      config,
      pkgs,
      ...
    }: {
      nixpkgs.overlays = [inputs.hermes-agent.overlays.default];

      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories =
            lib.filter (
              d: let
                dir =
                  if builtins.isString d
                  then d
                  else d.directory;
              in
                !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
            ) [
              "/var/lib/hermes"
              "/root/.hermes"
            ];
          users.${config.custom.user.name} = {
            directories = [
              ".hermes"
              ".cache/hermes"
            ];
          };
        };
      };

      environment.systemPackages = [pkgs.hermes-agent];

      environment.variables.HERMES_HOME = "/var/lib/hermes";

      systemd.tmpfiles.rules = [
        "d /var/lib/hermes 0750 root root -"
        "d /var/lib/hermes/workspace 0750 root root -"
        "d /var/lib/hermes/.hermes 0750 root root -"
      ];
      systemd.services.hermes = {
        description = "Hermes Agent";
        after = ["network.target"];
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "simple";
          User = "root";
          WorkingDirectory = "/var/lib/hermes/workspace";
          Environment = "HERMES_HOME=/var/lib/hermes/";
          ExecStart = "${pkgs.hermes-agent}/bin/hermes gateway run --replace";
          Restart = "on-failure";
          RestartSec = 5;
        };
      };
    };
  };
}
