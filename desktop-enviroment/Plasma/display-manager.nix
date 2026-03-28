_: {
  flake = {
    nixosModules.plasma-dm = {pkgs, ...}: {
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
