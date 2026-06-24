_: {
  perSystem = {pkgs, ...}: {
    packages.sops-easy = pkgs.writeShellScriptBin "sops-easy" ''
      if [ -f /persist/etc/ssh/ssh_host_ed25519_key ]; then
        KEY=/persist/etc/ssh/ssh_host_ed25519_key
      else
        KEY=/etc/ssh/ssh_host_ed25519_key
      fi

      SOPS_AGE_KEY=$(${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i $KEY | tail -1)

      ${pkgs.sops}/bin/sops "$@"
    '';
  };
}
