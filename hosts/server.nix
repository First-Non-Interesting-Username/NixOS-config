{
  self,
  inputs,
  lib,
  ...
}: let
  Hostname = "Server";
  Username = "nixi";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
  Domain = "iameasytoremember.duckdns.org";
  Width = 2560;
  Height = 1440;
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      username = Username;
      gitName = GitName;
      gitEmail = GitEmail;
      hostname = Hostname;
      domain = Domain;
      width = Width;
      height = Height;
    };
    modules = [
      # System modules go here
      self.nixosModules.home-manager
      self.nixosModules.git
      self.nixosModules.secrets
      self.nixosModules.ssh-server
      self.nixosModules.shell
      self.nixosModules.bootloader
      self.nixosModules.nix
      self.nixosModules.user
      self.nixosModules.networking-server
      self.nixosModules.locale
      self.nixosModules.hardware-Server
      self.nixosModules.virtualization-server
      self.nixosModules.nps
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
          domain = Domain;
          width = Width;
          height = Height;
        };
        home-manager.users.nixi = {
          imports = [
            # Home manager modules go here
            self.homeModules.home-manager
            self.homeModules.git
            self.homeModules.secrets
            self.homeModules.ssh
            self.homeModules.shell
            self.homeModules.direnv
            self.homeModules.theme
            self.homeModules.nps
          ];
        };
      }
    ];
  };
}
