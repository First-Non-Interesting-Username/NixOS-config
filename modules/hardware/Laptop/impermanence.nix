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

      boot.tmp.cleanOnBoot = true;

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
          "/var/lib/sddm"
          "/var/lib/AccountsService"
          "/var/lib/containers"
          "/var/lib/waydroid"
          "/var/lib/flatpak"
          "/var/lib/sunshine"
          "/var/lib/sops-nix"
          "/tmp"
          "/var/cache/tuigreet"
          "/etc/nixos"
        ];

        files = [
          "/etc/machine-id"
          "/etc/adjtime"
          "/etc/ssh/ssh_host_ed25519_key"
          "/etc/ssh/ssh_host_ed25519_key.pub"
        ];

        users.${username} = {
          directories = [
            "Projects"
            "Persist"
            "Games"
            ".ssh"
            ".config/sops/age"
            ".local/share/atuin"
            ".local/share/zoxide"
            ".local/share/direnv"
            ".config/zsh"
            ".local/share/Trash"
            ".cache/tealdeer"
            ".local/share/nix-index"
            ".mozilla"
            ".floorp"
            ".config/google-chrome"
            ".local/share/kwalletd"
            ".local/share/baloo"
            ".local/share/kactivitymanagerd"
            ".local/share/kscreen"
            ".config/session"
            ".config/plasma-org.kde.plasma.desktop-appletsrc"
            ".config/plasmashellrc"
            ".config/kwinrc"
            ".config/kdeglobals"
            ".local/share/Steam"
            ".local/share/PrismLauncher"
            {
              directory = ".cache/mesa_shader_cache";
              mode = "0755";
            }
            ".config/heroic"
            ".config/lutris"
            ".local/share/lutris"
            ".factorio"
            ".config/vesktop"
            ".local/share/containers"
            ".config/containers"
            ".local/share/waydroid"
            ".local/share/distrobox"
            ".config/VSCodium"
            ".vscode-oss"
            ".config/zed"
            ".local/share/wakatime"
            ".local/share/flatpak"
            ".local/state"
            ".cache/fontconfig"
          ];

          files = [
            ".wakatime.cfg"
          ];
        };
      };
    };
  };
}
