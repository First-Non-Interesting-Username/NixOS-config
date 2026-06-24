> [!NOTE]
> Humans SHOULD NOT modify this file, it should be fully vibe created.
> When you modify this file change the footer to `Last modified by [modelName], DD.MM.YYYY`.

# AGENTS.md

This file provides guidance for AI assistants working with this NixOS configuration repository.

## Project Overview

This is a flake-based NixOS configuration using the [flake-parts](https://github.com/hercules-ci/flake-parts) module system. Configurations are split into reusable modules and host-specific settings.

## Repository Structure

```
.
├── hosts/          # Host-specific NixOS configurations
├── modules/        # Reusable NixOS modules (imported via import-tree)
│   └── configuration/
├── devShells/      # Development shell definitions
├── secrets/        # SOPS-encrypted secrets (age)
├── flake.nix       # Flake entry point
└── .sops.yaml      # SOPS key configuration
```

## Development Environment

Enter the development shell with:

```bash
nix develop
```

Or with direnv:

```bash
direnv allow
```

The dev shell includes:

- `alejandra` - Nix formatter
- `nil` - Nix language server
- `yamllint` - YAML linter
- `vscodium` with Nix and Prettier extensions

## Code Standards

### Nix Style

Formatting:

- All `.nix` files MUST be formatted with `alejandra`.
- Lines SHOULD NOT exceed 100 characters.

Naming:

- Attribute names MUST use `camelCase`.
- File names MUST use `kebab-case`.
- Module option names MUST use `camelCase`.

Imports:

- Imports SHOULD be sorted alphabetically within their group.
- Standard library imports SHOULD appear before local imports.

General:

- `with lib;` at the top level of a module MUST NOT be used. Use explicit `lib.` prefixes instead.

### Module Structure

Each NixOS module MUST follow this pattern (based on `modules/configuration/template.nix`):

```nix
{
  self,
  inputs,
  ...
}: {
  flake = {
    nixosModules.MODULE_NAME = {
      pkgs,
      lib,
      config,
      username,
      impermanence,
      ...
    }: {
      imports = lib.optional impermanence {
        environment.persistence."/persist" = {
          directories = [];
          files = [];
          users.${username} = {
            directories = [];
            files = [];
          };
        };
      };

      # System config here

      home-manager.users.${username} = {
        pkgs,
        lib,
        config,
        osConfig,
        ...
      }: {
        # Home config here
      };
    };
  };
}
```

### Conventions

Documents follow the conventions in `CONVENTIONS.md`:

- Use simple present tense and active voice.
- Headings MUST NOT end with punctuation.
- Code MUST be inside syntax-highlighted code blocks.
- Documents MUST be formatted with Prettier.

## Secrets Handling

This repository uses [sops-nix](https://github.com/Mic92/sops-nix) with [age](https://github.com/FiloSottile/age) encryption.

### Key Derivation

Age keys are derived from SSH host private keys:

```bash
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | tail -1
```

### Editing Secrets

```bash
# Edit encrypted secrets
sops secrets/secrets.yaml

# Encrypt plaintext file in-place
sops --encrypt --in-place secrets/secrets.yaml
```

### Adding New Secrets

1. Add the new key to `.sops.yaml` with the system age key reference.
2. Edit `secrets/secrets.yaml` with `sops`.
3. Use `mkpasswd -m sha-512` for password hashes.

## Available Commands

### Formatting

```bash
alejandra .
```

### Validation

```bash
# Check all flake outputs
nix flake check

# Build specific host
nixos-rebuild build --flake .#<hostname>
```

### Secrets

```bash
sops secrets/secrets.yaml
```

## Commit Message Format

AI agents (including opencode GitHub Actions) MUST follow [Conventional Commits](https://www.conventionalcommits.org/) when creating commits:

```
<type>(<scope>): <short description>

[optional body]
```

Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`, `revert`

Scopes: `hosts`, `modules`, `home`, `pkgs`, `lib`, `flake`

Description rules:

- Use imperative mood (`add`, `fix`, not `added`, `fixes`).
- Start with lowercase.
- No trailing period.

## Pull Request Checklist

- [ ] Code follows style guidelines.
- [ ] `nix flake check` passes.
- [ ] Documentation is updated if needed.
- [ ] Commit messages follow Conventional Commits.
- [ ] Secrets are properly encrypted.

---

Last modified by MiniMax M2.5, 28.03.2026
