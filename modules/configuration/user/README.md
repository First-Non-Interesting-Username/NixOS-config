# User

## nixosModules.home-manager

- Enables Home Manager.
- Lets Home Manager manage itself.

## nixosModules.user

Configured via `custom.user` options (provided by `modules/nixos/args/user.nix`).

- Creates a user with the configured name.
- Adds it to various groups.
- Sets a password for it with the configured option.

## nixosModules.xdg

- Creates xdg directories, with location based on preservation enablement
