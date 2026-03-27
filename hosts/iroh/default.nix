{
  self,
  inputs,
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
      self.nixosModules.bootloader
      self.nixosModules.git
      self.nixosModules.home-manager
      self.nixosModules.locale
      self.nixosModules.networking-server
      self.nixosModules.nix
      self.nixosModules.nps
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh
      self.nixosModules.ssh-server
      self.nixosModules.theme
      self.nixosModules.update
      self.nixosModules.user
      self.nixosModules.virtualization-server
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
