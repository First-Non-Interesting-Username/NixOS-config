{
  self,
  inputs,
  lib,
  ...
}: let
  Hostname = "Laptop";
  Username = "nixi";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
  Width = 1920;
  Height = 1080;
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      username = Username;
      gitName = GitName;
      gitEmail = GitEmail;
      width = Width;
      height = Height;
      hostname = Hostname;
    };
    modules = [
      # System modules go here
      self.nixosModules.home-manager
      self.nixosModules.flatpak
      self.nixosModules.git
      self.nixosModules.secrets
      self.nixosModules.ssh
      self.nixosModules.shell
      self.nixosModules.bootloader
      self.nixosModules.update
      self.nixosModules.nix
      self.nixosModules.wayland
      self.nixosModules.input
      self.nixosModules.user
      self.nixosModules.virtualization-desktop
      self.nixosModules.sunshine
      self.nixosModules."hardware-${Hostname}"
      self.nixosModules.networking-desktop
      self.nixosModules.audio
      self.nixosModules.printing
      self.nixosModules.security
      self.nixosModules.locale
      self.nixosModules.power
      # self.nixosModules.plasma
      self.nixosModules.hyprland
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
        home-manager.users.nixi = {
          imports = [
            # Home manager modules go here
            self.homeModules.home-manager
            self.homeModules.flatpak
            self.homeModules.git
            self.homeModules.secrets
            self.homeModules.ssh
            self.homeModules.shell
            self.homeModules.virtualization-desktop
            self.homeModules.IDE
            self.homeModules.direnv
            self.homeModules.theme
            self.homeModules.browser
            self.homeModules.plasma
          ];
        };
      }
    ];
  };
}
