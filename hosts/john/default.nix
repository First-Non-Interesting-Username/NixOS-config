{
  self,
  inputs,
  ...
}: let
  Hostname = "john";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      inherit Hostname;
    };
    modules = [
      {_module.args.hostName = Hostname;}
      ./configuration.nix
      ./modules.nix
      self.nixosModules.audio
      self.nixosModules.browser
      self.nixosModules.input
      self.nixosModules.iso-graphical
      self.nixosModules.GNOME
      self.nixosModules.home-manager
      self.nixosModules.locale
      self.nixosModules.networking-minimal
      self.nixosModules.nix
      self.nixosModules.power
      self.nixosModules.terminal
      self.nixosModules.secretless-git
      self.nixosModules.ssh-debug
      self.nixosModules.sudo
      self.nixosModules.xdg
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

  flake.packages.x86_64-linux.${Hostname} =
    self.nixosConfigurations.${Hostname}.config.system.build.isoImage;
}
