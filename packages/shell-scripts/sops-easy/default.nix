_: {
  perSystem = {pkgs, ...}: {
    packages.sops-easy = pkgs.writeShellApplication {
      name = "sops-easy";

      runtimeInputs = [pkgs.sops pkgs.coreutils pkgs.sudo];

      text = ''
        if [ -f /persist/etc/ssh/ssh_host_ed25519_key ]; then
          KEY=/persist/etc/ssh/ssh_host_ed25519_key
        else
          KEY=/etc/ssh/ssh_host_ed25519_key
        fi

        sudo env "SOPS_AGE_SSH_PRIVATE_KEY_CMD=cat $KEY" sops "$@"
      '';
    };
  };
}
