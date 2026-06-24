{
  self,
  inputs,
  ...
}: let
  Hostname = "armin";
  GitName = "First-Non-Interesting-Username";
  GitEmail = "janekmusin@proton.me";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
      gitName = GitName;
      gitEmail = GitEmail;
      impermanence = true;
    };
    modules = [
      {_module.args.hostName = Hostname;}
      ./modules.nix
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
      self.nixosModules.locale
      self.nixosModules.moonlight
      self.nixosModules.nasClient
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
      self.nixosModules.update
      self.nixosModules.virtualization-desktop
      self.nixosModules.wayland
      self.nixosModules.xdg
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit self inputs;
          gitName = GitName;
          gitEmail = GitEmail;
        };
      }
    ];
  };
}
