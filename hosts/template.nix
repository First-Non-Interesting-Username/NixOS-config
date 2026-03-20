{
  self,
  inputs,
  lib,
  ...
}: let
  Hostname = "YOUR_HOSTNAME";
  Username = "YOUR_USERNAME";
  GitName = "YOUR_GIT_USERNAME";
  GitEmail = "YOUR_GIT_EMAIL";
  Width = 1920; # Width of your monitor in pixels, it will default to 1920
  Height = 1080; # Width of your monitor in pixels, it will default to 1080
  # some modules expect "domain", those modules are only for my personal use, open an issue if you need assistance with them
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      username = Username;
      gitName = GitName;
      gitEmail = GitEmail;
      hostname = Hostname;
    };
    modules = [
      # System modules go here
      self.nixosModules."hardware-${Hostname}"
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          username = Username;
          gitName = GitName;
          gitEmail = GitEmail;
          hostname = Hostname;
          width = Width;
          height = Height;
        };
      }
    ];
  };
}
