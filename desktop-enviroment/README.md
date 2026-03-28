# Desktop Environments

## nixosModules.plasma

Enables KDE Plasma 6 desktop environment with the following components:

- **plasma-config**: Configures X server, Plasma 6, and home-manager plasma-manager.
- **plasma-dm**: Sets up SDDM display manager.
- **plasma-apps**: Installs default KDE applications.
- **plasma-other**: Handles XDG portal configuration and impermanence persistence.

### Key Features

- Polish keyboard layout with caps/escape swap.
- Breeze Dark look and feel with Gruvbox-inspired color scheme.
- Custom keyboard shortcuts (Meta+Q close, Meta+F fullscreen, etc.).
- KRunner centered with Meta+D and Meta+Space launchers.
- Dolphin (Meta+E), Kitty (Meta+Return), and Spectacle (Shift+Print) integrations.

## nixosModules.hyprland

Enables Hyprland Wayland compositor with the following components:

- **hyprland-config**: Configures Hyprland with home-manager.
- **hyprland-dm**: Sets up SDDM display manager.
- **hyprland-apps**: Installs default Wayland applications.
- **hyprland-other**: Handles XDG portal configuration and impermanence.
- **noctalia**: Custom shell integration for IPC commands.

### Key Features

- Uses Hyprland from flake input with cachix.
- XWayland enabled for X11 compatibility.
- Custom keybindings (Super+Return terminal, Super+D menu, Super+E file manager).
- Workspace management with 10 persistent workspaces.
- Magic special workspace for floating windows.
- Smooth animations and window transitions.
- Volume and brightness control via media keys.
- Grimblast screenshot integration (Shift+Print).
- Hyprspace plugin for workspace isolation.
- Vicinae application launcher.
