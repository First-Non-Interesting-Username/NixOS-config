{
  self,
  inputs,
  ...
}: let
  Hostname = "armin";
  Username = "nixi";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
  Width = 2256;
  Height = 1504;
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      username = Username;
      gitName = GitName;
      gitEmail = GitEmail;
      hostname = Hostname;
      impermanence = true;
    };
    modules = [
      ./hardware.nix
      self.nixosModules.audio
      self.nixosModules.bootloader
      self.nixosModules.browser
      self.nixosModules.direnv
      self.nixosModules.flatpak
      self.nixosModules.git
      self.nixosModules.GNOME
      self.nixosModules.home-manager
      self.nixosModules.IDE
      self.nixosModules.impermanence
      self.nixosModules.input
      self.nixosModules.kernel-laptop
      self.nixosModules.locale
      self.nixosModules.moonlight
      self.nixosModules.networking-desktop
      self.nixosModules.nix
      self.nixosModules.opencode
      self.nixosModules.power
      self.nixosModules.printing
      self.nixosModules.programs-desktop
      self.nixosModules.secrets
      self.nixosModules.shell
      self.nixosModules.ssh
      self.nixosModules.terminal
      self.nixosModules.theme
      self.nixosModules.update
      self.nixosModules.user
      self.nixosModules.virtualization-desktop
      self.nixosModules.wayland
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          username = Username;
          gitName = GitName;
          gitEmail = GitEmail;
          width = Width;
          height = Height;
          hostname = Hostname;
        };
      }
    ];
  };
}
