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
      imports = [
        inputs.sops-nix.nixosModules.sops
        # TODO: Create secrets module (same concept as preservation module)
        self.nixosModules.shell-secret-programs
      ];

      preservation.preserveAt = lib.mkIf config.custom.preservation.enable {
        "/persist" = {
          directories = lib.filter (
            d: let
              dir =
                if builtins.isString d
                then d
                else d.directory;
            in
              !(config.fileSystems ? "/var/lib" && lib.hasPrefix "/var/lib" dir)
          ) ["/var/lib/sops-nix"];
          users.${config.custom.user.name} = {
            directories = [".config/sops/age"];
          };
        };
      };

      environment.systemPackages = with pkgs; [
        sops
        age
        ssh-to-age
        self.packages.${pkgs.stdenv.hostPlatform.system}.sops-easy
      ];

      sops = {
        defaultSopsFile = "${self}/secrets/secrets.yaml";
        age =
          if config.custom.preservation.enable
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
