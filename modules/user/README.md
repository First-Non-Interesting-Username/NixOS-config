# User

## self.nixosModules.home-manager

- Enables Home Manager.
- Lets Home Manager manage itself.

## self.nixosModules.user

- Creates a user with username passed via special arg.
- Adds it to various groups.
- Sets a password for it.

## self.nixosModules.user-debug

- Sets root password to `debug`.
