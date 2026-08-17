# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  flake = {
    nixosModules.nasServer = {
      lib,
      config,
      ...
    }: {
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
              "/var/lib/nfs"
            ];
        };
      };

      services.nfs.server = {
        enable = true;
        lockdPort = 4045;
        mountdPort = 4046;
        statdPort = 4047;
        exports = ''
          /mnt/storage  192.168.0.0/24(rw,sync,no_subtree_check,no_root_squash)
        '';
      };
      networking.firewall = {
        allowedTCPPorts = [111 2049 4045 4046 4047];
        allowedUDPPorts = [111 2049 4045 4046 4047];
      };
    };
    nixosModules.nasClient = {
      lib,
      config,
      ...
    }: {
      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories = [
            "/var/lib/nfs"
          ];
        };
      };

      boot.supportedFilesystems = ["nfs"];
      fileSystems."/mnt/storage" = {
        device = "192.168.0.10:/mnt/storage";
        fsType = "nfs";
        options = [
          "x-systemd-automount"
          "noauto"
          "x-systemd.idle-timeout=600"
          "rw"
        ];
      };
    };
  };
}
