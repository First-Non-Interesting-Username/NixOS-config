{
  self,
  inputs,
  ...
}: {
  flake = {
    homeModules.terminal = {
      pkgs,
      lib,
      config,
      ...
    }: {
      programs = {
        foot = {
          enable = true;
          server.enable = true;
        };

        kitty = {
          enable = true;
          enableGitIntegration = true;
          shellIntegration.enableZshIntegration = true;
          settings = {
            tab_bar_style = "hidden";
            confirm_os_window_close = 0;
            scrollback_lines = 10000;
            wheel_scroll_multiplier = 5.0;
            copy_on_select = true;
            strip_trailing_spaces = "smart";
            enable_audio_bell = false;
            visual_bell_duration = 0.0;
            cursor_shape = "beam";
            cursor_stop_blinking_after = 15.0;
            repaint_delay = 10;
            input_delay = 3;
            sync_to_monitor = true;
          };
        };
      };
    };
  };
}
