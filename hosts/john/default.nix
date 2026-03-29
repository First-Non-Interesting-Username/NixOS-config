{
  self,
  inputs,
  ...
}: let
  Hostname = "john";
  Username = "nixi";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      inherit Username Hostname;
      username = Username;
      hostname = Hostname;
      gitName = "ISO-User";
      gitEmail = "iso@nixos.local";
      impermanence = false;
    };
    modules = [
      self.nixosModules.audio
      self.nixosModules.bootloader
      self.nixosModules.browser
      self.nixosModules.input
      self.nixosModules.iso
      self.nixosModules.iso-graphical
      self.nixosModules.GNOME
      self.nixosModules.home-manager
      self.nixosModules.locale
      self.nixosModules.networking-minimal
      self.nixosModules.nix
      self.nixosModules.power
      self.nixosModules.theme
      self.nixosModules.secretless-git
      self.nixosModules.secretless-user
      self.nixosModules.shell
      self.nixosModules.ssh-debug
      self.nixosModules.user-debug
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          username = Username;

          hostname = Hostname;
          width = 1920;
          height = 1080;
        };
      }
    ];
  };

  flake.packages.x86_64-linux.${Hostname} =
    self.nixosConfigurations.${Hostname}.config.system.build.isoImage;
}
