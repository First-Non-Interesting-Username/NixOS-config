{inputs, ...}: {
  perSystem = {
    system,
    pkgs,
    config,
    ...
  }: let
    extensions = inputs.nix-vscode-extensions.extensions.${system};
  in {
    devShells.default = pkgs.mkShellNoCC {
      buildInputs = [
        pkgs.yamllint
        pkgs.alejandra
        pkgs.nil
        (pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscodium;
          vscodeExtensions = with extensions.vscode-marketplace; [
            bbenoist.nix
            esbenp.prettier-vscode
            wakatime.vscode-wakatime
            jnoortheen.nix-ide
          ];
        })
      ];

      shellHook = config.pre-commit.shellHook;
    };

    pre-commit.settings.hooks = {
      alejandra.enable = true;
      nil.enable = true;
    };
  };
}
