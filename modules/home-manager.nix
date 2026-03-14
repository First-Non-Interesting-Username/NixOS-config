{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.home-manager = {
      pkgs,
      lib,
      config,
      ...
    }: {
      imports = [
        inputs.home-manager.nixosModules.home-manager
      ];
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        backupFileExtension = "backup";
      };
    };

    homeModules.home-manager = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      programs.home-manager.enable = true;
      home.stateVersion = "26.05";
      home.homeDirectory = "/home/${username}";
    };
  };
}
