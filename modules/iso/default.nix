_: {
  flake = {
    nixosModules.iso = {
      pkgs,
      modulesPath,
      username,
      ...
    }: {
      imports = [
        (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
      ];

      environment.defaultPackages = with pkgs; [
        nano
        netcat
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
