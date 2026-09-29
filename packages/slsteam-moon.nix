# SPDX-FileCopyrightText: 2026 first-uninteresting-username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{self, ...}: {
  perSystem = {
    pkgs,
    lib,
    system,
    ...
  }: let
    name = "slsteam-moon";

    profile = self.nixosConfigurations.armin.config.programs.steam.package.drvAttrs.profile or "";

    ldAudit = let
      lines = lib.filter (line: lib.hasPrefix "LD_AUDIT=" line) (lib.splitString "\n" profile);
    in
      lib.concatMap (line: lib.splitString ":" (lib.removePrefix "LD_AUDIT=" line)) lines;

    artefacts = lib.filter (path: lib.hasInfix "-${name}-" path) ldAudit;
  in
    lib.optionalAttrs (system == "x86_64-linux") {
      packages.${name} =
        if artefacts == []
        then throw "no ${name} path in the Steam wrapper's LD_AUDIT, so its derivation cannot be reached"
        else
          pkgs.runCommand name {} ''
            mkdir -p "$out"
            cp ${lib.concatStringsSep " " artefacts} "$out/"
          '';
    };
}
