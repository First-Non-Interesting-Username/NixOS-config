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
      username,
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
      home-manager.users.${username} = {
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
  };
}
