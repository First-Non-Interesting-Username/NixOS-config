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
      ...
    }: {
      programs.git.enable = lib.mkForce false;

      environment.systemPackages = with pkgs; [
        git
        gh
      ];
      sops.secrets.github_pat = {
        owner = username;
      };
    };
    homeModules.git = {
      pkgs,
      lib,
      config,
      gitName,
      gitEmail,
      osConfig,
      ...
    }: {
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
            git_protocol = "ssh";
            prompt = "enabled";
          };
        };
      };

      programs.zsh.initExtra = ''
        export GH_TOKEN="$(cat ${osConfig.sops.secrets.github_pat.path})"
      '';
    };
  };
}
