{
  self,
  inputs,
  ...
}: let
  Hostname = "Minimal";
  Username = "nixi";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
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
      impermanence = false;
    };
    modules = [
      # System modules go here
      self.nixosModules.bootloader
      self.nixosModules.git
      self.nixosModules.locale
      self.nixosModules.networking-minimal
      self.nixosModules.nix
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh-debug
      self.nixosModules.theme
      self.nixosModules.user
      self.nixosModules.home-manager
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
