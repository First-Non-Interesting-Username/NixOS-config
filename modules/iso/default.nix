{self, ...}: {
  flake = {
    nixosModules.iso = {
      username,
      pkgs,
      ...
    }: {
      environment.defaultPackages = with pkgs; [
        nano
        netcat
        disko
        nixos-anywhere
        micro
      ];

      isoImage.contents = [
        {
          source = self.outPath;
          target = "/flake-source";
        }
      ];

      systemd.tmpfiles.rules = [
        "C /etc/nixos - - - - /flake-source"
        "Z /etc/nixos 0777 ${username} ${username} -"
      ];

      home-manager.users.${username} = {
        osConfig,
        lib,
        ...
      }: {
        home.stateVersion = lib.mkForce osConfig.system.stateVersion;
      };
    };
  };
}
