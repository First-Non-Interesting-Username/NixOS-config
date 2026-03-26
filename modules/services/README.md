# Services

## nixosModules.nps

PERSONAL

IMPERATIVE:

- Set up authelia one time password 2FA.
- Set up the ARR stack as you would on normal server

###

- Sets up services for my home server.

## nixosModules.secrets

- Sets up secrets management system with sops.
- Sets host SSH key as a default key for age, which is used for sops.

## nixosModules.secrets-impermanence

- Sets up secrets management system with sops.
- Sets host SSH key with path changed to include persist directory as a default key for age, which is used for sops.

## nixosModules.ssh

Secrets: ssh_keys/private/${hostname}, ssh_keys/public/${hostname}

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories with sops.

## nixosModules.ssh-impermanence

Secrets: ssh_keys/private/${hostname}, ssh_keys/public/${hostname}

PERSONAL

- Sets up SSH with my public keys.
- Installs Lazyssh.
- Puts my SSH public and private keys to right directories (now with persist, so they work with impermanence) with sops.

## nixosModules.ssh-debug

- Opens SSH for everyone, with root login.

## nixosModules.ssh-server

- Sets up SSH server on port 6767 (Yes, this is a 67 joke).
- Sets fail2ban for SSH.

## nixosModules.update

- Installs Nh and sets up automatic cleaning.
- Sets up Nh flake to remote of my flake.
- Enables weekly store optimizes.
- Enables daily automatic updates.
