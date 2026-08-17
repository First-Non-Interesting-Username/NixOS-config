# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{inputs, ...}: {
  flake = {
    nixosModules.agents = {
      lib,
      config,
      pkgs,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              ".config/opencode"
              ".local/share/opencode"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = _: {
        programs = {
          opencode = {
            package = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.opencode;
            enable = true;
          };
          ssh.settings = {
            "hermes" = {
              IdentityFile = "~/.ssh/id_ed25519";
              HostName = "hackclub.app";
              # I'm not from Serbia, serbian is my fav meme linux distro
              # https://distrowatch.com/table.php?distribution=serbian
              # Well, I hope it is a meme distro
              User = "serbian";
              Port = 22;
              RequestTTY = "force";
              RemoteCommand = "hermes; exec $SHELL -l";
            };
          };
        };

        home.packages = [
          inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system}.kilocode-cli
        ];
      };
    };
  };
}
