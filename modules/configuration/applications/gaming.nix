# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  flake = {
    nixosModules.gaming = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          users.${config.custom.user.name} = {
            directories = [
              "homes"
            ];
          };
        };
      };

      home-manager.users.${config.custom.user.name} = {
        config,
        lib,
        ...
      }: {
        home.activation.createGboxDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
          mkdir -p "${config.home.homeDirectory}/homes/Gbox"
        '';

        programs.distrobox = {
          containers = {
            Gbox = {
              image = "ghcr.io/first-non-interesting-username/gbox-gnome-amd:20260809";
              init = false;
              root = false;
              start_now = false;
              exported_apps = "steam lutris protonup-qt prismlauncher";
              init_hooks = "/usr/local/bin/prism-instance-bootstrap.sh";
              home = "${config.home.homeDirectory}/homes/Gbox";
            };
          };
        };
      };
    };
  };
}
