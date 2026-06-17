{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.secrets = {
      pkgs,
      lib,
      impermanence,
      username,
      config,
      ...
    }: {
      imports =
        [
          inputs.sops-nix.nixosModules.sops
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = lib.filter (
              d: let
                dir =
                  if builtins.isString d
                  then d
                  else d.directory;
              in
                !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
            ) ["/var/lib/sops-nix"];
            users.${username} = {
              directories = [".config/sops/age"];
            };
          };
        };

      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        age =
          if impermanence
          then {
            generateKey = false;
            sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
          }
          else {
            sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
          };
      };
    };
  };
}
