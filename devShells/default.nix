{ inputs, ... }:
{
  perSystem =
    { system, pkgs, ... }:
    let
      extensions = inputs.nix-vscode-extensions.extensions.${system};

      vscodium-with-settings = pkgs.vscodium.override {
        profileSetting = {
          "editor.defaultFormatter" = "esbenp.prettier-vscode";
          "editor.formatOnSave" = true;
          "[nix]" = {
            "editor.defaultFormatter" = "jnoortheen.nix-ide";
          };
          "nix.enableLanguageServer" = true;
          "nix.serverPath" = "nil";
          "nix.formatterPath" = "alejandra";
        };
      };
    in
    {
      devShells.default = pkgs.mkShellNoCC {
        buildInputs = [
          pkgs.yamllint
          pkgs.alejandra
          pkgs.nil
          (pkgs.vscode-with-extensions.override {
            vscode = vscodium-with-settings;
            vscodeExtensions = with extensions.vscode-marketplace; [
              bbenoist.nix
              esbenp.prettier-vscode
              WakaTime.vscode-wakatime
              jnoortheen.nix-ide
            ];
          })
        ];
      };
    };
}
