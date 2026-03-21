{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.power = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services = {
        upower.enable = true;
        power-profiles-daemon.enable = true;
      };
    };
  };
}
