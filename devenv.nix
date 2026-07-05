{pkgs, ...}: {
  languages.nix.enable = true;

  packages = with pkgs; [
    yamllint
    alejandra
    nixd
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

  files.".zed/settings.json".json = {
    languages.Nix = {
      language_servers = [
        "nixd"
        "!nil"
      ];
      formatter = {
        external = {
          command = "alejandra";
          arguments = [
            "--quiet"
            "--"
          ];
        };
      };
    };
    lsp.nixd = {
      initialization_options = {
        formatting = {
          command = ["alejandra"];
        };
      };
    };
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
