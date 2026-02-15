{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland-dm = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs.regreet.enable = true;
    };
  };
}
