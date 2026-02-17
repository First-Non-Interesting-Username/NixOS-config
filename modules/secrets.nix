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

    homeModules.secrets = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        inputs.sops-nix.homeManagerModules.sops
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
      };
    };
  };
}
