{
  self,
  inputs,
  ...
}: let
  Hostname = "iroh";
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
      gitName = GitName;
      gitEmail = GitEmail;
      domain = Domain;
      width = Width;
      height = Height;
      impermanence = true;
    };
    modules = [
      {_module.args.hostName = Hostname;}
      ./hardware.nix
      ./modules.nix
      self.nixosModules.bootloader
      self.nixosModules.git
      self.nixosModules.home-manager

      self.nixosModules.home-server-iroh
      self.nixosModules.impermanence
      self.nixosModules.locale
      self.nixosModules.nasServer
      self.nixosModules.networking-server
      self.nixosModules.nix
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh
      self.nixosModules.ssh-server
      self.nixosModules.theme
      self.nixosModules.update
      self.nixosModules.virtualization-server
      self.nixosModules.xdg
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          gitName = GitName;
          gitEmail = GitEmail;
          domain = Domain;
        };
      }
    ];
  };
}
