# Desktop

## nixosModules.input

- Sets Polish keyboard layout with caps/escape swap.
- Sets natural scrolling for both mouse and touchpad.
- Enables Steam Controller udev rules.

## nixosModules.theme

- Enables Qt with Breeze theme.
- Enables GTK theming.
- Enables Stylix for comprehensive theming.

### Theme Configuration

- **Base16 Scheme**: Gruvbox Dark.
- **Cursor**: Bibata Modern Ice (24px).
- **Icon Theme**: Papirus (Dark/Light variants).
- **Fonts**:
  - Monospace: JetBrains Mono Nerd Font.
  - Sans Serif: DejaVu Sans.
  - Serif: DejaVu Serif.
  - Emoji: Noto Color Emoji.
- **Wallpaper**: Custom SVG-based Gruvbox-inspired wallpaper.

### Disabled Targets

Disables Stylix targets for: VSCode colors, KDE, Qt, and Floorp.

## nixosModules.wayland

- Enables GPU/graphics drivers with 32-bit support (Steam/Wine compatibility).
- Enables PolicyKit for privileged operations.
- Sets Wayland system environment variables.
- Enables D-Bus.
- Installs core Wayland packages.
