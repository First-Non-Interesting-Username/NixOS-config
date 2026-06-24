{inputs, ...}: {
  flake = {
    nixosModules.home-manager = {config, ...}: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
      };
      home-manager.users.${config.custom.user.name} = {osConfig, ...}: {
        programs.home-manager.enable = true;
        home.homeDirectory = "/home/${osConfig.custom.user.name}";
        home.enableNixpkgsReleaseCheck = false;
      };
    };
  };
}
