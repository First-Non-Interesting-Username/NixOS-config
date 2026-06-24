{
  self,
  inputs,
  ...
}: let
  Hostname = "wall-e";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      inherit Hostname;
      hostname = Hostname;
      gitName = "ISO-User";
      gitEmail = "iso@nixos.local";
      width = 1920;
      height = 1080;
      impermanence = false;
    };
    modules = [
      ./configuration.nix
      ./modules.nix
      self.nixosModules.input
      self.nixosModules.iso-terminal
      self.nixosModules.home-manager
      self.nixosModules.locale
      self.nixosModules.networking-minimal
      self.nixosModules.nix
      self.nixosModules.power
      self.nixosModules.theme
      self.nixosModules.secretless-git
      self.nixosModules.shell
      self.nixosModules.ssh-debug
      self.nixosModules.xdg
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          hostname = Hostname;
        };
      }
    ];
  };

  flake.packages.x86_64-linux.${Hostname} =
    self.nixosConfigurations.${Hostname}.config.system.build.isoImage;
}
