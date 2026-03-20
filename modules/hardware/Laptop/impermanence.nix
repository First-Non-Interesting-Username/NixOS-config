{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.impermanence-Laptop = {
      config,
      lib,
      username,
      ...
    }: {
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
          "/etc/NetworkManager"
          "/var/lib/NetworkManager"
          "/etc/ssh"
          "/var/lib/cups"
          "/var/lib/bluetooth"
          "/var/lib/AccountsService"
          "/var/lib/sunshine"
          "/var/lib/sops-nix"
          "/tmp"
          "/var/cache/tuigreet"
          "/etc/nixos"
        ];

        files = [
          "/etc/adjtime"
        ];

        users.${username} = {
          directories = [
            "Projects"
            "Persist"
            "Games"
            "Downloads"
            ".config/sops/age"
            ".local/state"
            ".cache/fontconfig"
          ];

          files = [
          ];
        };
      };
    };
  };
}
