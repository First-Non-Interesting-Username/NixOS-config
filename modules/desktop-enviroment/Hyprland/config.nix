{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.hyprland-config = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs.hyprland = {
        enable = true;
        withUWSM = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
        portalPackage =
          inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
      };
    };
    homeModules.hyprland-config = {
      pkgs,
      lib,
      config,
      ...
    }: {
      wayland.windowManager.hyprland = {
        enable = true;
        systemd.enable = false;
        plugins = [
          inputs.Hyprspace.packages.${pkgs.stdenv.hostPlatform.system}.Hyprspace
        ];
        package = null;
        portalPackage = null;

        settings = {
          "$mod" = "SUPER";
          "$terminal" = "kitty";
          "$fileManager" = "dolphin";
          "$menu" = "vicinae";
          "$ipc" = "noctalia-shell ipc call";

          general = {
            gaps_in = 5;
            gaps_out = 10;
            border_size = 2;
            layout = "dwindle";

            "col.active_border" = lib.mkForce (
              "rgba(${config.lib.stylix.colors.base08}ff) "
              + "rgba(${config.lib.stylix.colors.base09}ff) "
              + "rgba(${config.lib.stylix.colors.base0A}ff) "
              + "rgba(${config.lib.stylix.colors.base0B}ff) "
              + "rgba(${config.lib.stylix.colors.base0C}ff) "
              + "rgba(${config.lib.stylix.colors.base0D}ff) "
              + "rgba(${config.lib.stylix.colors.base0E}ff) "
              + "rgba(${config.lib.stylix.colors.base0F}ff) "
              + "rgba(${config.lib.stylix.colors.base00}ff) "
              + "45deg"
            );

            "col.inactive_border" = lib.mkForce "rgba(${config.lib.stylix.colors.base03}aa)";
          };

          misc = {
            force_default_wallpaper = 0;
            disable_hyprland_logo = true;
            disable_splash_rendering = true;
            mouse_move_enables_dpms = true;
            key_press_enables_dpms = true;
          };

          layerrule = [
            "blur, vicinae"
            "ignorealpha 0, vicinae"
            "noanim, vicinae"
          ];

          workspace = [
            "1, persistent:true"
            "2, persistent:true"
            "3, persistent:true"
            "4, persistent:true"
            "5, persistent:true"
            "6, persistent:true"
            "7, persistent:true"
            "8, persistent:true"
            "9, persistent:true"
            "10, persistent:true"

            "special:magic, persistent:true"
          ];

          bezier = [
            "smoothOut, 0.36, 0, 0.66, -0.56"
            "smoothIn, 0.25, 1, 0.5, 1"
            "smooth, 0.4, 0.0, 0.2, 1.0"
          ];

          animation = [
            "windows, 1, 3, smooth, slide"
            "windowsIn, 1, 3, smoothIn, slide"
            "windowsOut, 1, 3, smoothOut, slide"
            "windowsMove, 1, 3, smooth"

            "fadeIn, 1, 3, smoothIn"
            "fadeOut, 1, 3, smoothOut"
            "fadeDim, 1, 4, smooth"

            "border, 1, 4, smooth"

            "workspaces, 1, 3, smooth, slide"

            "specialWorkspace, 1, 4, smooth, slidefadevert -100%"
          ];

          decoration = {
            dim_special = 0.9;
            dim_inactive = false;
          };

          bindm = [
            "$mod, mouse:272, movewindow"
            "$mod, mouse:273, resizewindow"
          ];

          bindle = [
            ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
            ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
            ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
            ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
          ];

          bindl = [
            ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
          ];

          bind = [
            "$mod, RETURN, exec, $terminal"
            "$mod, D, exec, $menu"
            "$mod, E, exec, $fileManager"

            "$mod, Q, killactive,"
            "$mod, M, exit,"
            "$mod, V, togglefloating,"
            "$mod, P, pseudo,"
            "$mod, J, togglesplit,"
            "$mod, F, fullscreen,"

            "$mod, h, movefocus, l"
            "$mod, l, movefocus, r"
            "$mod, k, movefocus, u"
            "$mod, j, movefocus, d"
            "$mod, left, movefocus, l"
            "$mod, right, movefocus, r"
            "$mod, up, movefocus, u"
            "$mod, down, movefocus, d"

            "$mod CONTROL, h, swapwindow, l"
            "$mod CONTROL, l, swapwindow, r"
            "$mod CONTROL, k, swapwindow, u"
            "$mod CONTROL, j, swapwindow, d"
            "$mod CONTROL, left, swapwindow, l"
            "$mod CONTROL, right, swapwindow, r"
            "$mod CONTROL, up, swapwindow, u"
            "$mod CONTROL, down, swapwindow, d"

            "binde = $mod SHIFT, h, resizeactive, -20 0"
            "binde = $mod SHIFT, l, resizeactive, 20 0"
            "binde = $mod SHIFT, k, resizeactive, 0 -20"
            "binde = $mod SHIFT, j, resizeactive, 0 20"
            "binde = $mod SHIFT, left, resizeactive, -20 0"
            "binde = $mod SHIFT, right, resizeactive, 20 0"
            "binde = $mod SHIFT, up, resizeactive, 0 -20"
            "binde = $mod SHIFT, down, resizeactive, 0 20"

            "$mod, 1, workspace, 1"
            "$mod, 2, workspace, 2"
            "$mod, 3, workspace, 3"
            "$mod, 4, workspace, 4"
            "$mod, 5, workspace, 5"
            "$mod, 6, workspace, 6"
            "$mod, 7, workspace, 7"
            "$mod, 8, workspace, 8"
            "$mod, 9, workspace, 9"
            "$mod, 0, workspace, 10"

            "$mod SHIFT, 1, movetoworkspace, 1"
            "$mod SHIFT, 2, movetoworkspace, 2"
            "$mod SHIFT, 3, movetoworkspace, 3"
            "$mod SHIFT, 4, movetoworkspace, 4"
            "$mod SHIFT, 5, movetoworkspace, 5"
            "$mod SHIFT, 6, movetoworkspace, 6"
            "$mod SHIFT, 7, movetoworkspace, 7"
            "$mod SHIFT, 8, movetoworkspace, 8"
            "$mod SHIFT, 9, movetoworkspace, 9"
            "$mod SHIFT, 0, movetoworkspace, 10"

            "$mod CONTROL, 1, movetoworkspacesilent, 1"
            "$mod CONTROL, 2, movetoworkspacesilent, 2"
            "$mod CONTROL, 3, movetoworkspacesilent, 3"
            "$mod CONTROL, 4, movetoworkspacesilent, 4"
            "$mod CONTROL, 5, movetoworkspacesilent, 5"
            "$mod CONTROL, 6, movetoworkspacesilent, 6"
            "$mod CONTROL, 7, movetoworkspacesilent, 7"
            "$mod CONTROL, 8, movetoworkspacesilent, 8"
            "$mod CONTROL, 9, movetoworkspacesilent, 9"
            "$mod CONTROL, 0, movetoworkspacesilent, 10"

            "$mod, S, togglespecialworkspace, magic"
            "$mod SHIFT, S, movetoworkspace, special:magic"
            "$mod CONTROL, S, movetoworkspacesilent, special:magic"

            "$mod, G, exec, hexecute"
            "$mod, F, fullscreen,"
            "SHIFT, Print, exec, grimblast --freeze copy area"

            "$mod, B, exec, $ipc launcher clipboard"
            "$mod, Escape, exec. $ipc sessionMenu toggle"

            "$mod, mouse:275, exec, hyprnome"
            "$mod, mouse:276, exec, hyprnome --previous"
            "$mod, mouse_down, exec, hyprnome"
            "$mod, mouse_up, exec, hyprnome --previous"

            "$mod, D, overview:toggle"
            "$mod, Space, exec, vicinae toggle && hyprctl dispatch focuswindow vicinae"
          ];
        };
      };
    };
  };
}
