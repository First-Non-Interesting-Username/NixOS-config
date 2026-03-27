_: {
  flake = {
    nixosModules.wayland = {
      pkgs,
      username,
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
      home-manager.users.${username} = _: {
        home.sessionVariables = {
          NIXOS_OZONE_WL = "1";
          SDL_VIDEODRIVER = "wayland";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          MOZ_ENABLE_WAYLAND = "1";
        };
      };
    };
  };
}
