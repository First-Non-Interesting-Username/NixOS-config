_: {
  perSystem = {pkgs, ...}: let
    checkname = "CHANGEME";
  in {
    checks.${checkname} = pkgs.testers.runNixOSTest {
      name = checkname;

      nodes.default = _: {
        # VM config goes here
      };

      testScript = ''
        # Python test script
        # https://nixos.org/manual/nixos/unstable/#ssec-machine-objects - docs
      '';
    };
  };
}
