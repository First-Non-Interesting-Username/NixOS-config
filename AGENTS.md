# AGENTS.md

This file provides guidance for AI assistants working with this NixOS configuration repository.

## Project Overview

This is a flake-based NixOS configuration using [flake-parts](https://github.com/hercules-ci/flake-parts) and [import-tree](https://github.com/vic/import-tree). Configurations are split into reusable modules and host-specific settings. Hosts are composed of modules imported from `self.nixosModules`.

## Repository Structure

```
.
├── hosts/              # Host-specific NixOS configurations
│   ├── armin/          # Real host (laptop/desktop)
│   ├── iroh/           # Real host (server)
│   ├── victim/         # Real host (desktop)
│   ├── wall-e/         # Installation ISO host
│   ├── john/           # Installation ISO host
│   ├── common/         # Shared host module (e.g. desktop-modules.nix)
│   └── template/       # Copy this to start a new host
├── modules/
│   ├── configuration/  # Reusable NixOS modules (imported via import-tree)
│   │   ├── applications/
│   │   ├── desktop/
│   │   ├── development/
│   │   ├── iso/
│   │   ├── services/
│   │   ├── system/
│   │   └── user/
│   └── nixos/          # Flake-level options/plumbing
│       ├── args/       # custom.* options (hostname, user, preservation, stylix)
│       ├── desktop-envinroment/
│       ├── server/
│       └── shell/
├── packages/           # Custom packages / shell scripts (perSystem)
│   ├── mirrors/
│   └── shell-scripts/  # rebuild, sops-easy, template
├── secrets/            # SOPS-encrypted secrets (age)
├── docs/               # Documentation (host-names, install-guides)
├── flake.nix           # Flake entry point
└── .sops.yaml          # SOPS key configuration
```

## How Modules Are Loaded

`flake.nix` wires everything via `import-tree`:

```nix
imports = [
  (inputs.import-tree ./modules)
  (inputs.import-tree ./packages)
  (inputs.import-tree.match ".*/[^/]+/default\\.nix" ./hosts)
];
```

- `modules/` and `packages/` are imported recursively (every `default.nix` becomes an output).
- `hosts/` are matched by any `*/default.nix` (or `_default.nix`) one level deep, each producing a `flake.nixosConfigurations.<name>`.

## Development Environment

The dev environment is provided by [devenv](https://devenv.sh/) (`devenv.nix` + `devenv.yaml`), not a `devShells/` attribute.

Enter it with:

```bash
devenv shell
```

Or with direnv (after `direnv allow`).

The dev environment provides:

- `alejandra` - Nix formatter (also enforced on commit via git-hooks).
- `nixd` - Nix language server.
- `yamllint` - YAML linter.
- Editor config (`.vscode` / `.zed`) wiring `nixd` and `alejandra`.

## Code Standards

### Headers

Every `.nix` file MUST begin with the SPDX license header:

```nix
# SPDX-FileCopyrightText: 2026 First-Non-Interesting-Username
#
# SPDX-License-Identifier: GPL-3.0-or-later
```

### Nix Style

- All `.nix` files MUST be formatted with `alejandra`.
- Lines SHOULD NOT exceed 100 characters.

Naming:

- Attribute names MUST use `camelCase`.
- File names MUST use `kebab-case`.

Imports & scope:

- `with lib;` at the top level MUST NOT be used. Use explicit `lib.` prefixes.

### Module Structure

Reusable modules follow the `flake.nixosModules` pattern. The canonical form for a module that needs no flake inputs:

```nix
_: {
  flake = {
    nixosModules.MODULE_NAME = {
      lib,
      config,
      ...
    }: {
      # System config here
    };
  };
}
```

When a module needs flake inputs (e.g. to import another flake's module), use the explicit form:

```nix
{inputs, ...}: {
  flake = {
    nixosModules.MODULE_NAME = {
      lib,
      config,
      ...
    }: {
      imports = [
        inputs.preservation.nixosModules.preservation
      ];
    };
  };
}
```

Modules define their options under `options.custom.*` (see `modules/nixos/args/`) and read them via `config.custom.*`. Hosts opt into modules by listing `self.nixosModules.<name>` in their `modules.nix`.

### Hostname Convention

The `hostname` specialArg is NO LONGER used. Instead:

1. Each host's `_default.nix` (or `default.nix`) sets `_module.args.hostName` to the hostname string inside `nixosSystem`.
2. Each host's `modules.nix` sets `custom.hostname = hostName;` (sourced from `_module.args.hostName`).
3. The `self.nixosModules.hostname` module reads `config.custom.hostname` to set `networking.hostName`.
4. All other modules access the hostname via `config.custom.hostname` instead of the old `hostname` specialArg.

### Conventions

Documents follow the conventions in `CONVENTIONS.md` (if present):

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

# Encrypt a plaintext file in-place
sops --encrypt --in-place secrets/secrets.yaml
```

### Adding New Secrets

1. Add the new key to `.sops.yaml` with the system age key reference.
2. Edit `secrets/secrets.yaml` with `sops`.
3. For user password hashes use `mkpasswd -m yescrypt` (the `custom.user` options expect a yescrypt hash, not sha-512).

## Available Commands

### Development Shell

```bash
devenv shell       # enter the dev environment
direnv allow       # auto-enter via direnv
```

### Formatting

```bash
alejandra .
```

Formatting is also checked automatically on commit through devenv's git-hooks.

### Validation

```bash
# Check all flake outputs
nix flake check

# Build a specific host
nixos-rebuild build --flake .#<hostname>
```

### Rebuilding a Host

The `rebuild` package (under `packages/shell-scripts/rebuild`) wraps `nh` and deploys the host from this flake on GitHub:

```bash
rebuild   # runs: nh os boot github:First-Non-Interesting-Username/NixOS-Config/main#$HOSTNAME
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

- [ ] Code follows style guidelines (alejandra formatted).
- [ ] `nix flake check` passes.
- [ ] Documentation is updated if needed.
- [ ] Commit messages follow Conventional Commits.
- [ ] Secrets are properly encrypted.

---

Last modified by opencode/hy3-free, 13.08.2026
