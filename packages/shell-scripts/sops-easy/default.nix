_: {
  perSystem = {pkgs, ...}: {
    packages.sops-easy = pkgs.writeShellScriptBin "sops-easy" ''
      if [ -f /persist/etc/ssh/ssh_host_ed25519_key ]; then
        KEY=/persist/etc/ssh/ssh_host_ed25519_key
      else
        KEY=/etc/ssh/ssh_host_ed25519_key
      fi

      /run/wrappers/bin/sudo env "SOPS_AGE_SSH_PRIVATE_KEY_CMD=${pkgs.coreutils}/bin/cat $KEY" ${pkgs.sops}/bin/sops "$@"
    '';
    };
  };
}
