# Desktop

## self.nixosModules.input

- Sets polish keyboard layout with caps swap.
- Sets natural scrolling for both mouse and touchpad.
- Enables Steam Controller udev rules.

## self.nixosModules.theme

- Enables Qt and sets the theme to breeze.
- Enables GTK.
- Enables Stylix.

###

- Sets:
- Theme to Gruvbox Dark.
- Cursor to Bibata Modern Ice.
- Icon theme to Papirus.
- Monospace font to JetBrains Mono Nerd Font.
- Sans Serif font to DejaVu Sans.
- Serif font to DejaVu Serif.
- Emoji font to Noto Color Emoji.

###

- Disables the following stylix targets: Vscode colors, KDE, QT and Floorp.

## self.nixosModules.wayland

- Enables GPU/graphics drivers, including 32-bit support (needed for things like Steam/Wine).
- Enables PolicyKit, a system for controlling privileged operations.
- Sets system-wide environment variables that tell apps to use Wayland instead of XWayland.
- Enables D-Bus.
- Installs core Wayland packages.
