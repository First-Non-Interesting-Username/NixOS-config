{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.git = {
      pkgs,
      lib,
      config,
      username,
      impermanence,
      gitName,
      gitEmail,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          users.${username} = {
            directories = [
              ".config/git"
              ".config/gh"
            ];
          };
        };
      };

      programs.git.enable = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        git
        gh
      ];
      sops.secrets.github_pat = {
        owner = username;
      };
      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        osConfig,
        ...
      }: {
        home.packages = with pkgs; [onefetch];
        programs = {
          git = {
            enable = true;
            settings = {
              user.name = gitName;
              user.email = gitEmail;
              init.defaultBranch = "main";
              pull.rebase = true;
            };
          };
          gh = {
            enable = true;
            settings = {
              # gh ssh-key add ~/.ssh/id_ed25519.pub
              git_protocol = "ssh";
              prompt = "enabled";
            };
          };
        };

        programs.zsh.initContent = ''
          export GH_TOKEN="$(cat ${osConfig.sops.secrets.github_pat.path})"
        '';
      };
    };
  };
}
