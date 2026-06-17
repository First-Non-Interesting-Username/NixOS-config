{inputs, ...}: {
  flake = {
    nixosModules.impermanence = {
      lib,
      username,
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
          "d /persist/home/${username} 0700 ${username} users -"
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
              "/etc/ssh"
              "/tmp"
              "/etc/nixos"
            ];

          files = [
            "/etc/adjtime"
          ];

          users.${username} = {
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
        home-manager.users.${username} = _: {
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
