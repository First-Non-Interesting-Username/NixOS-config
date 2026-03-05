{
  self,
  inputs,
  ...
}:
{
  flake = {
    nixosModules.git =
      {
        pkgs,
        lib,
        config,
        ...
      }:
      {
        programs.git.enable = lib.mkForce false;

        environment.systemPackages = with pkgs; [
          git
          gh
        ];
      };
    homeModules.git =
      {
        pkgs,
        lib,
        config,
        gitName,
        gitEmail,
        ...
      }:
      {
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
        sops.secrets.github_pat = { };

        home.sessionVariables = {
          GH_TOKEN = config.sops.secrets.github_pat.path;
          NIX_CONFIG = "access-tokens = github.com=${config.sops.secrets.github_pat.path}";
        };
      };
  };
}
