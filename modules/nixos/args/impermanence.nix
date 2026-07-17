{inputs, ...}: {
  flake = {
    nixosModules.impermanence = {
      lib,
      config,
      ...
    }: let
      cfg = config.custom.impermanence;
    in {
      imports = [
        inputs.impermanence.nixosModules.impermanence
      ];

      options.custom.impermanence = {
        enable = lib.mkEnableOption "impermanence module. It may work unpredictably if you don't have /persist partition.";
      };

      config = lib.mkIf cfg.enable {
        boot = {
          initrd.systemd.enable = true;
          tmp.cleanOnBoot = true;
        };

        systemd.tmpfiles.rules = [
          "d /persist/home/${config.custom.user.name} 0700 ${config.custom.user.name} users -"
        ];

        environment.persistence."/persist" = {
          hideMounts = true;

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
              "/var/lib/nixos"
              "/var/lib/systemd"
              "/var/log"
              "/tmp"
              "/var/lib/AccountsService"
            ];

          files = [
            "/etc/adjtime"
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
            "/etc/machine-id"
          ];

          users.${config.custom.user.name} = {
            directories = [
              ".cache/mesa_shader_cache"
              "persist"
              ".cache/fontconfig"
            ];

            files = [
            ];
          };
        };

        fileSystems = {
          "/" = {
            neededForBoot = true;
          };
          "/nix" = {
            neededForBoot = true;
          };
          "/persist" = {
            neededForBoot = true;
          };
        };
        home-manager.users.${config.custom.user.name} = _: {
          programs = {
            zsh.initContent = ''
              if [[ $PWD == $HOME ]]; then
                  cd ~/persist
              fi
            '';
            nushell.extraConfig = ''
              if $env.PWD == $env.HOME {
                cd ~/persist
              }
            '';
          };
        };
      };
    };
  };
}
