# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
_: {
  perSystem = {pkgs, ...}: {
    packages.sops-easy = pkgs.writeShellApplication {
      name = "sops-easy";
      runtimeInputs = with pkgs; [
        sops
        ssh-to-age
      ];
      text = ''
        if [ -f /persist/etc/ssh/ssh_host_ed25519_key ]; then
          KEY=/persist/etc/ssh/ssh_host_ed25519_key
        else
          KEY=/etc/ssh/ssh_host_ed25519_key
        fi

        SOPS_AGE_KEY=$(ssh-to-age -private-key -i "$KEY" | tail -1)
        export SOPS_AGE_KEY

        sops "$@"
      '';
    };
  };
}
