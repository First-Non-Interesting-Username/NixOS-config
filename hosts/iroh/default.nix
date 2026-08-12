# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
{
  self,
  inputs,
  ...
}: let
  Hostname = "iroh";
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
      self.nixosModules.bootloader
      self.nixosModules.git
      self.nixosModules.home-manager
      self.nixosModules.home-server-iroh
      self.nixosModules.locale
      self.nixosModules.nasServer
      self.nixosModules.networking-server
      self.nixosModules.nix
      self.nixosModules.secrets
      self.nixosModules.smart
      self.nixosModules.ssh
      self.nixosModules.ssh-server
      self.nixosModules.sudo
      self.nixosModules.tty
      self.nixosModules.update
      self.nixosModules.virtualization-server
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
}
