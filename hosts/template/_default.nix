{
  self,
  inputs,
  ...
}: let
  Hostname = "YOUR_HOSTNAME";
in {
  flake.nixosConfigurations.${Hostname} = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit self inputs;
    };
    modules = [
      {_module.args.hostName = Hostname;}
      ./modules.nix
      ./hardware.nix
      # Modules go here, remember to reference them with self. prefix
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
