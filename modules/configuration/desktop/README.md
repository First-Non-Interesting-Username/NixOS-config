# Desktop

## nixosModules.input

- Sets Polish keyboard layout with caps/escape swap.
- Sets natural scrolling for both mouse and touchpad.
- Enables Steam Controller udev rules.

## nixosModules.noctalia

Custom shell environment for Hyprland or Niri with the following features:

- Bar: Top-positioned simple bar with launcher, clock, system monitor, active window, media mini, workspace, tray, notifications, battery, volume, brightness, and control center.
- Control Center: Network, Bluetooth, wallpaper selector, notifications, power profile, keep awake, night light shortcuts.
- App Launcher: Clipboard history, terminal integration, searchable settings and windows.
- Dock: Bottom-positioned auto-hide dock with pinned apps.
- Notifications: Top-right notifications with history.
- Session Menu: Lock, suspend, hibernate, logout, reboot, shutdown options.
- System Monitor: CPU, memory, disk, network monitoring with configurable thresholds.
- Lock Screen: Compact lock screen with session buttons.
- Weather: Location-based weather display (Kielce default).

## nixosModules.theme

- Enables Qt with Breeze theme.
- Enables GTK theming.
- Enables Stylix for comprehensive theming.

NixOS Logo designed by Tim Cuthbertson (@timbertson).

The NixOS logo is licensed under the [Creative Commons Attribution 4.0
International License](http://creativecommons.org/licenses/by/4.0/).

### Theme Configuration

- Base16 Scheme: Gruvbox Dark.
- Cursor: Bibata Modern Ice (24px).
- Icon Theme: Papirus (Dark/Light variants).
- Fonts:
  - Monospace: JetBrains Mono Nerd Font.
  - Sans Serif: DejaVu Sans.
  - Serif: DejaVu Serif.
  - Emoji: Noto Color Emoji.
- Wallpaper: Custom SVG-based Gruvbox-inspired wallpaper.

### Disabled Targets

Disables Stylix targets for: VSCode colors, KDE, Qt, and Floorp.

## nixosModules.wayland

- Enables GPU/graphics drivers with 32-bit support (Steam/Wine compatibility).
- Enables PolicyKit for privileged operations.
- Sets Wayland system environment variables.
- Enables D-Bus.
- Installs core Wayland packages.
