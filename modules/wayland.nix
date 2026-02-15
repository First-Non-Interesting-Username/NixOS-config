{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.wayland = {
      pkgs,
      lib,
      config,
      ...
    }: {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
      };
      security.polkit.enable = true;
      environment.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
      services.dbus.enable = true;
      environment.systemPackages = with pkgs; [
        wayland
        wayland-protocols
        wl-clipboard
      ];
    };
    homeModules.wayland = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.sessionVariables = {
        NIXOS_OZONE_WL = "1";
        SDL_VIDEODRIVER = "wayland";
        _JAVA_AWT_WM_NONREPARENTING = "1";
        MOZ_ENABLE_WAYLAND = "1";
      };
    };
  };
}
