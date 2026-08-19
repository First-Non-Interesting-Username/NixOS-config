<<<<<<< HEAD:checks/_example-checks/basic.nix
# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
=======
>>>>>>> 952a5bc (style: nix maintenance (statix, deadnix, alejandra)):checks/_template.nix
_: {
  perSystem = {pkgs, ...}: let
    checkname = "CHANGEME";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

<<<<<<< HEAD:checks/_example-checks/basic.nix
      # Gh actions aarch64 runners don't have qemu
      requiredFeatures.kvm = pkgs.stdenv.hostPlatform.isx86_64;

      nodes.machine = _: {
=======
      nodes.default = _: {
>>>>>>> 952a5bc (style: nix maintenance (statix, deadnix, alejandra)):checks/_template.nix
        # VM config goes here
      };

      testScript = ''
        # Python test script
        # https://nixos.org/manual/nixos/unstable/#ssec-machine-objects - docs
      '';
    };
  };
}
