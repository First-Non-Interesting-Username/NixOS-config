{
  self,
  inputs,
  ...
}: let
  Hostname = "hedwig";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
    };
    modules = [
      {_module.args.hostName = Hostname;}
      ./hardware.nix
      ./modules.nix
      self.nixosModules.git
      self.nixosModules.home-manager
      self.nixosModules.locale
      self.nixosModules.nix
      self.nixosModules.secrets
      self.nixosModules.ssh
      self.nixosModules.ssh-server
      self.nixosModules.sudo
      self.nixosModules.update
      self.nixosModules.xdg
      self.nixosModules.vlh-agent
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
        };
      }
    ];
  };
}
