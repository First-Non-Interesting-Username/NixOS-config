{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.input = {
      pkgs,
      lib,
      config,
      ...
    }: {
      console.keyMap = "pl";
      environment.variables = {
        XKB_DEFAULT_LAYOUT = "pl";
        XKB_DEFAULT_VARIANT = "";
        XKB_DEFAULT_OPTIONS = "caps:escape";
      };
      services.xserver.xkb = {
        layout = "pl";
        variant = "";
      };
      services.libinput = {
        enable = true;

        touchpad = {
          naturalScrolling = true;
          tapping = true;
          disableWhileTyping = true;
          clickMethod = "clickfinger";
          accelSpeed = "0.4";
        };
        mouse = {
          accelProfile = "flat";
          middleEmulation = true;
        };
      };
      hardware.steam-hardware.enable = true;
      services.udev.packages = [pkgs.game-devices-udev-rules];
    };

    homeModules.input = {
      pkgs,
      lib,
      config,
      ...
    }: {
      home.keyboard = {
        layout = "pl";
        variant = "";
        options = ["caps:escape"];
      };

      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.addons = [
          pkgs.fcitx5-mozc
          pkgs.fcitx5-gtk
          pkgs.kdePackages.fcitx5-qt
        ];
      };
    };
  };
}
