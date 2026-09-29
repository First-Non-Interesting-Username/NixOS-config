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
    checkname = "slsteam-moon";

    # nix-crab compiles slsteam-moon from source with an i686 toolchain but only
    # reaches it through programs.steam.package, publishing no package output.
    # CI builds neither armin nor victim, so nothing ever compiled the fork and
    # the cost was deferred to the first host switch.
    #
    # Pull the artefacts back out of the Steam wrapper so CI compiles them
    # instead. nix-crab injects them into LD_AUDIT, which nixpkgs bakes into the
    # wrapper's profile script, so that string is the only handle left. Its
    # substrings keep their string context, which is what makes referencing the
    # store paths below build the fork rather than merely name it.
    profile = self.nixosConfigurations.armin.config.programs.steam.package.drvAttrs.profile or "";

    ldAudit = let
      lines = lib.filter (line: lib.hasPrefix "LD_AUDIT=" line) (lib.splitString "\n" profile);
    in
      lib.concatMap (line: lib.splitString ":" (lib.removePrefix "LD_AUDIT=" line)) lines;

    artefacts = lib.filter (path: lib.hasInfix "-${checkname}-" path) ldAudit;
  in
    lib.optionalAttrs (system == "x86_64-linux") {
      checks.${checkname} =
        if artefacts == []
        then
          throw ''
            no ${checkname} path in the Steam wrapper's LD_AUDIT, so its
            derivation cannot be reached; teach this check how to find it
          ''
        else
          pkgs.runCommand checkname {} ''
            mkdir -p "$out"
            cp ${lib.concatStringsSep " " artefacts} "$out/"
          '';
    };
}
