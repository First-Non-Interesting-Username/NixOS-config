{inputs, ...}: {
  flake = {
    nixosModules.impermanence = {
      lib,
      impermanence,
      config,
      ...
    }: {
      imports = lib.optional impermanence {
        imports = [
          inputs.impermanence.nixosModules.impermanence
        ];

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
          ];

          users.${config.custom.user.name} = {
            directories = [
              ".cache/mesa_shader_cache"
              "persist"
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
          programs.zsh.initContent = ''
            if [[ $PWD == $HOME ]]; then
                cd ~/persist
            fi
          '';
        };
      };
    };
  };
}
