{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.plasma-dm = {
      pkgs,
      lib,
      config,
      ...
    }: {
      services.displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        theme = "sddm-astronaut-theme";
        extraPackages = [pkgs.sddm-astronaut];
      };

      environment.systemPackages = [pkgs.sddm-astronaut];
    };
  };
}
