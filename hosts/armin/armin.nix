{
  self,
  inputs,
  lib,
  ...
}:
let
  Hostname = "armin";
  Username = "nixi";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
  Width = 1920;
  Height = 1080;
in
{
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
      # System modules go here
      self.nixosModules.home-manager
      self.nixosModules.flatpak
      self.nixosModules.git
      self.nixosModules.secrets-impermanence
      self.nixosModules.ssh-impermanence
      self.nixosModules.shell
      self.nixosModules.bootloader
      self.nixosModules.update
      self.nixosModules.nix
      self.nixosModules.wayland
      self.nixosModules.input
      self.nixosModules.user
      self.nixosModules.virtualization-desktop
      # self.nixosModules."hardware-${Hostname}"
      self.nixosModules.networking-desktop
      self.nixosModules.audio
      self.nixosModules.printing
      self.nixosModules.locale
      self.nixosModules.power
      self.nixosModules.plasma
      # self.nixosModules.hyprland
      self.nixosModules.gaming
      self.nixosModules.programs-desktop
      self.nixosModules.kernel-laptop
      self.nixosModules.terminal
      self.nixosModules.theme
      self.nixosModules.browser
      self.nixosModules.IDE
      self.nixosModules.direnv
      self.nixosModules.moonlight
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
