{
  self,
  inputs,
  lib,
  ...
}: let
  Hostname = "iroh";
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
      impermanence = false;
    };
    modules = [
      ./hardware.nix
      self.nixosModules.home-manager
      self.nixosModules.git
      self.nixosModules.secrets
      self.nixosModules.ssh-server
      self.nixosModules.ssh
      self.nixosModules.shell
      self.nixosModules.bootloader
      self.nixosModules.nix
      self.nixosModules.user
      self.nixosModules.networking-server
      self.nixosModules.locale
      self.nixosModules.virtualization-server
      self.nixosModules.nps
      self.nixosModules.update
      self.nixosModules.theme
      self.nixosModules.direnv
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
      }
    ];
  };
}
