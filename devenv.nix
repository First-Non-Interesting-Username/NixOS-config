{pkgs, ...}: {
  languages.nix.enable = true;

  packages = with pkgs; [
    yamllint
    alejandra
    nixd
  ];

  files.".vscode/settings.json" = {
    copyMode = "copy";
    json = {
      editor.defaultFormatter = "esbenp.prettier-vscode";
      editor.formatOnSave = true;
      "[nix]" = {
        editor.defaultFormatter = "jnoortheen.nix-ide";
      };
      nix.enableLanguageServer = true;
      nix.serverPath = "nixd";
      nix.formatterPath = "alejandra";
    };
  };

  files.".vscode/extensions.json" = {
    copyMode = "copy";
    json = {
      recommendations = [
        "jnoortheen.nix-ide"
        "esbenp.prettier-vscode"
        "wakatime.vscode-wakatime"
      ];
    };
  };

  files.".zed/settings.json" = {
    copyMode = "copy";
    json = {
      languages.Nix = {
        language_servers = [
          "nixd"
          "!nil"
          "..."
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
