# Development

## self.nixosModules.direnv

- Installs Direnv with Zsh integration and nix-direnv.

## self.nixosModules.git

IMPERATIVE:

- Run `gh ssh-key add ~/.ssh/id_ed25519.pub` to add the SSH key of the machine to github.

###

- Installs Git and GH.
- Installs Onefetch, for Fastfetch like overviews of Git repos.
- Sets up Git with username and email provided by the user.
- Sets default branch to main (Why isn't it default?).
- Sets up GH with default git protocol being SSH and automatically logs you in.

## self.nixosModules.IDE

WIP

- Installs VSCodium with Nix-ide extension and few essential settings.
- Installs Micro.
- Installs Zed with few essential settings and Nix LSP support.
- Installs Nil and Alejandra.
- Sets VSCodium as an `EDITOR` and `VISUAL`.

## self.nixosModules.nix

- Enables essential experimental nix features.
- Unlocks the whole CPU for nix builds.
- Disables channels.
- Allows unfree packages and disallows broken ones.

## self.nixosModules.shell

- Installs Zsh systemwide and sets it up for your user.
- Enables Zsh for the user with few preferences set how I want them.

###

- Enables and sets up:
- Nix-index.
- Starship prompt.
- Atuin.
- Eza.
- Zoxide.
- Tealdeer.
- Television
- Pay-respects.
- Lazygit
- Btop.
- Bat.
- Fd.
- Fastfetch.
- Trash CLI.
- Ugrep.

## self.nixosModules.terminal

WIP

- Installs Foot and Kitty.
