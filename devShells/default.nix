{ inputs, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    let
      extensions = inputs.nix-vscode-extensions.extensions.${system};
    in
    {
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

        shellHook = ''
          HOOK_FILE=".git/hooks/pre-commit"
          if [ ! -f "$HOOK_FILE" ]; then
            cat > "$HOOK_FILE" << 'HOOK'
          #!/bin/sh
          staged=$(git diff --cached --name-only --diff-filter=ACM | grep '\.nix$')
          if [ -n "$staged" ]; then
            alejandra --quiet $staged
            git add -u
          fi
          HOOK
            chmod +x "$HOOK_FILE"
            echo "Installed alejandra pre-commit hook"
          fi
        '';
      };
    };
}
