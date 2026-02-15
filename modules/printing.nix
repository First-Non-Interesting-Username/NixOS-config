{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.printing = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      services.printing = {
        enable = true;
        drivers = with pkgs; [
          cups-filters
          cups-browsed
        ];
      };
    };
    homeModules.printing = {
      pkgs,
      lib,
      config,
      ...
    }: {
      # Home config goes here
    };
  };
}
