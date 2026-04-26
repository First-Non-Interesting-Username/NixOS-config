_: {
  perSystem = {
    pkgs,
    config,
    ...
  }: {
    devShells.default = pkgs.mkShellNoCC {
      buildInputs = [
        pkgs.yamllint
        pkgs.alejandra
        pkgs.nil
      ];

      inherit (config.pre-commit) shellHook;
    };

    pre-commit.settings.hooks = {
      alejandra.enable = true;
      nil.enable = true;
    };
  };
}
