# User

## nixosModules.home-manager

- Enables Home Manager.
- Lets Home Manager manage itself.

## nixosModules.user

Secrets: sudo_password/${hostname}

- Creates a user with username passed via special arg.
- Adds it to various groups.
- Sets a password for it.

## nixosModules.user-debug

- Sets root password to `debug`.
