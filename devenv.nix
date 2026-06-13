{pkgs, ...}: {
  languages.nix.enable = true;

  packages = with pkgs; [
    yamllint
    alejandra
  ];

  files.".vscode/settings.json".json = {
    editor.defaultFormatter = "esbenp.prettier-vscode";
    editor.formatOnSave = true;
    "[nix]" = {
      editor.defaultFormatter = "jnoortheen.nix-ide";
    };
    nix.enableLanguageServer = true;
    nix.serverPath = "nixd";
    nix.formatterPath = "alejandra";
  };

  files.".vscode/extensions.json".json = {
    recommendations = [
      "jnoortheen.nix-ide"
      "esbenp.prettier-vscode"
      "wakatime.vscode-wakatime"
    ];
  };

  git-hooks.hooks = {
    alejandra.enable = true;
  };

  devcontainer = {
    enable = true;
    settings.customizations.vscode.extensions = [
      "jnoortheen.nix-ide"
      "esbenp.prettier-vscode"
      "wakatime.vscode-wakatime"
    ];
  };
}
