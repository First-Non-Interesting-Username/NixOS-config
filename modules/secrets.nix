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
      ...
    }: {
      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
      ];

      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      };
    };

    nixosModules.secrets-impermanence = {
      pkgs,
      lib,
      config,
      ...
    }: {
      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
      ];

      imports = [
        inputs.sops-nix.nixosModules.sops
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        age = {
          generateKey = false;
          sshKeyPaths = ["/persist/etc/ssh/ssh_host_ed25519_key"];
        };
      };
    };
  };
}
