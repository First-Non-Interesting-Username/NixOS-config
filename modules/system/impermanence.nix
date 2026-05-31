{inputs, ...}: {
  flake = {
    nixosModules.impermanence = {
      lib,
      username,
      impermanence,
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

          directories = [
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
                cd ~/Persist
            fi
          '';
        };
      };
    };
  };
}
