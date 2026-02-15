{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.security = {
      pkgs,
      lib,
      config,
      inputs,
      ...
    }: {
      security.polkit.enable = true;
      imports = [
        inputs.nix-mineral.nixosModules.nix-mineral
      ];
      nix-mineral = {
        enable = true;
        preset = "compatibility";
      };
    };
  };
}
