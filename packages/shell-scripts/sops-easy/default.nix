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
        set -euo pipefail

        if [ -f /persist/var/lib/sops-nix/keys.txt ]; then
          KEY=/var/lib/sops-nix/keys.txt
        else
          KEY=/var/lib/sops-nix/keys.txt
        fi

        SOPS_AGE_KEY=$(ssh-to-age -private-key -i "$KEY" | tail -1)
        export SOPS_AGE_KEY

        sops "$@"
      '';
    };
  };
}
