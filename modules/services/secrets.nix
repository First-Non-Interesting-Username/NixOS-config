{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.secrets = {
      pkgs,
      lib,
      config,
      impermanence,
      username,
      ...
    }: {
      imports =
        [
          inputs.sops-nix.nixosModules.sops
        ]
        ++ lib.optional impermanence {
          environment.persistence."/persist" = {
            directories = ["/var/lib/sops-nix"];
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
