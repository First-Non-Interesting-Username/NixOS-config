{inputs, ...}: {
  flake = {
    nixosModules.home-manager = {username, ...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
      };
      home-manager.users.${username} = {username, ...}: {
        programs.home-manager.enable = true;
        home.homeDirectory = "/home/${username}";
        home.enableNixpkgsReleaseCheck = false;
      };
    };
  };
}
