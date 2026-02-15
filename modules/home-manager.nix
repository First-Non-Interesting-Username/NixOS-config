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
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
    };

    homeModules.home-manager = {
      pkgs,
      lib,
      config,
      username,
      ...
    }: {
      programs.home-manager.enable = true;
      home.stateVersion = "25.11";
      home.homeDirectory = "/home/${username}";
    };
  };
}
