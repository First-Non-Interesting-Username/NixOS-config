> [!IMPORTANT]
> If you find yourself lost with the terminology in this and other related files, read [CONVENTIONS.md](./CONVENTIONS.md).

> [!NOTE]
> As per [CLA.md](CLA.md) you are assinging the copyright for your work on this project to me, First-Non-Interesting-Username.
> This is made because I want to have flexablity to change the license for example.
> I don't expect much contributions anyway, if I ever get complains about it, I will change it.

# Contributing

This document defines the contribution process for this repository.
The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be
interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Table of Contents

- [Contributing](#contributing)
  - [Table of Contents](#table-of-contents)
  - [Code of Conduct](#code-of-conduct)
  - [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Setting Up the Repository](#setting-up-the-repository)
  - [How to Contribute](#how-to-contribute)
    - [Reporting Bugs](#reporting-bugs)
    - [Suggesting Features](#suggesting-features)
    - [Contributing Documentation](#contributing-documentation)
    - [Contributing Code](#contributing-code)
  - [Branch Naming](#branch-naming)
  - [Commit Messages](#commit-messages)
    - [Types](#types)
    - [Scopes](#scopes)
    - [Examples](#examples)
  - [Pull Requests](#pull-requests)
    - [Before Opening a Pull Request](#before-opening-a-pull-request)
    - [Pull Request Process](#pull-request-process)
    - [Pull Request Template](#pull-request-template)
  - [Code Standards](#code-standards)
    - [Nix Style](#nix-style)
    - [Module Structure](#module-structure)
    - [Testing](#testing)
  - [Documentation Standards](#documentation-standards)
  - [Review Process](#review-process)
  - [Acknowledgements](#acknowledgements)

---

## Code of Conduct

Follow [Code of Conduct](./CODE_OF_CONDUCT.md)

---

## Getting Started

### Prerequisites

The following tools MUST be installed before contributing:

- [Nix](https://nixos.org/download/) with flakes enabled.
- [Git](https://git-scm.com/).

The following tools are RECOMMENDED:

- [direnv](https://direnv.net/) with [nix-direnv](https://github.com/nix-community/nix-direnv) for automatic shell activation.
- [gh](https://github.com/cli/cli) for easier PR creation and

### Setting Up the Repository

1. Fork this repository.
2. Clone your fork:

```bash
git clone https://github.com/<your-username>/NixOS-config.git
cd NixOS-config
```

3a. Enter the development shell:

```bash
nix develop
```

3b. If you use direnv, instead run:

```bash
direnv allow
```

---

## How to Contribute

### Reporting Bugs

Before opening a bug report, check the existing issues to avoid duplicates.

A bug report MUST include:

- A clear and descriptive title.
- The relevant hardware or host configuration.
- Steps to reproduce the issue.
- The expected behaviour.
- The actual behaviour.
- Any relevant log output, inside a code block.

### Suggesting Features

Feature requests MUST include:

- A clear description of the proposed feature.
- The motivation or use case behind the request.
- Whether the feature is NixOS-specific or general.

Feature requests SHOULD include:

- A rough description of how the feature could be implemented.
- Links to relevant upstream documentation or modules.

### Contributing Documentation

Documentation contributions MUST follow the [Documentation Standards](#documentation-standards) defined in this document.

Documentation contributions MUST NOT introduce factual inaccuracies.

### Contributing Code

Code contributions MUST follow the [Code Standards](#code-standards) defined in this document.

Code contributions MUST be accompanied by updated documentation if the change affects user-facing behaviour.

---

## Branch Naming

Branches MUST follow this naming scheme:

```
<type>/<short-description>
```

The `<type>` MUST be one of the commit types defined in the [Commit Messages](#commit-messages) section.

The `<short-description>` MUST use `kebab-case`.

Examples of valid branch names:

```
feat/add-hyprland-module
fix/bluetooth-resume-after-suspend
docs/update-contributing-guide
refactor/split-home-manager-config
```

---

## Commit Messages

This repository follows the [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/) specification.

A commit message MUST follow this format:

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

The short description MUST:

- Use the imperative mood (e.g. `add`, `fix`, `remove`, not `added`, `fixes`).
- Start with a lowercase letter.
- Not end with a period.
- Not be too long (left to subjective definition).

The body SHOULD explain the _why_ behind a change, not the _what_.

### Types

The following types MUST be used:

- `feat`: A new feature or module.
- `fix`: A bug fix.
- `docs`: Documentation changes only.
- `style`: Formatting changes that do not affect meaning (whitespace, missing semicolons, etc.).
- `refactor`: A code change that neither fixes a bug nor adds a feature.
- `perf`: A change that improves performance.
- `test`: Adding or correcting tests.
- `chore`: Changes to the build process, tooling, or auxiliary files.
- `revert`: Reverts a previous commit.

### Scopes

The scope SHOULD identify the part of the codebase affected.
Scopes SHOULD correspond to top-level directories or named modules.

Examples of valid scopes:

- `hosts`
- `modules`
- `home`
- `pkgs`
- `lib`
- `flake`

### Examples

```
feat(modules): add Hyprland compositor module
fix(home): correct font rendering on HiDPI displays
docs(contributing): add branch naming section
refactor(hosts): split desktop and server host configs
```

---

## Pull Requests

### Before Opening a Pull Request

You MAY run the following checks before opening a pull request:

1. Run the Nix formatter and confirm no formatting errors remain:

```bash
alejandra .
```

2. Confirm the configuration evaluates without errors:

```bash
nix flake check
```

3. If the change affects a host configuration, build it locally:

```bash
nixos-rebuild build --flake .#<hostname>
```

### Pull Request Process

1. Open a pull request against the `main` branch.
2. Fill in the pull request template.
3. Ensure all automated checks pass.
4. Wait for review.

A pull request SHOULD NOT be merged by its own author.
A pull request MUST NOT be merged until all review comments are resolved.

A pull request SHOULD remain open for at least 2 hours before merging, to allow for review.

### Pull Request Template

```markdown
## Description

<!-- What does this change do? -->

## Motivation

<!-- Why is this change needed? -->

## Changes

- <!-- List the changes made -->

## Testing

<!-- How was this change tested? -->

## Checklist

- [ ] Code follows the style guidelines.
- [ ] `nix flake check` passes.
- [ ] Documentation is updated if needed.
- [ ] Commit messages follow Conventional Commits.
- [ ] You added yourself to [CONTRIBUTORS.md](./CONTRIBUTORS.md) (optional).
```

---

## Code Standards

### Nix Style

The following rules apply to all `.nix` files in this repository.

Formatting:

- All `.nix` files MUST be formatted with `alejandra`. If you use devshell, it will be done automatically.
- Lines SHOULD NOT exceed 100 characters.

Naming:

- Attribute names MUST use `camelCase`.
- File names MUST use `kebab-case`.
- Module option names MUST use `camelCase`.

Imports:

- Imports SHOULD be sorted alphabetically within their group.
- Standard library imports SHOULD appear before local imports.

General:

- `with lib;` at the top level of a module MUST NOT be used.
  Use explicit `lib.` prefixes instead.

### Module Structure

Each NixOS module in this repository MUST follow this structure and be based on the [template](./modules/template.nix).

### Testing

Changes MUST be verified to evaluate without errors using `nix flake check`.

Changes that affect a host configuration SHOULD be verified with a local build:

```bash
nixos-rebuild build --flake .#<hostname>
```

Changes that add new modules SHOULD include an example configuration in a comment or in the module's `meta.doc` if applicable.

---

## Documentation Standards

All documentation in this repository follows the conventions defined in the repository's [documentation style guide](CONVENTIONS.md).
The key rules that apply here are:

- Documents MUST be written in simple present tense.
- Sentences MUST be written in active voice.
- Simple English SHOULD be used.
  Avoid jargon and complex vocabulary where possible.
- Bullet lists SHOULD be used where applicable.
- Each line of text SHOULD contain only one sentence and MUST end with either a period or a colon.
- Documents MUST be in Markdown.
- Headings MUST NOT end with a punctuation mark.
- Code MUST be inside code blocks with syntax highlighting corresponding to the language.
- Documents MUST be formatted using the [Prettier](https://prettier.io/) formatter.

---

## Review Process

The review process follows these steps:

1. The author opens a pull request and fills in the template.
2. Automated checks run and MUST pass.
3. A reviewer reads the changes and leaves comments.
4. The author addresses all comments.
5. The reviewer approves the pull request.
6. The pull request is merged.

A reviewer SHOULD focus on:

- Correctness of the Nix expression.
- Adherence to code and documentation standards.
- Impact on other hosts or modules.
- Unnecessary complexity.

A reviewer MUST NOT approve a pull request that:

- Fails `nix flake check`.
- Lacks documentation for user-facing changes.

---

## Acknowledgements

This document draws inspiration from the following resources:

- [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).
- [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).
- [NixOS Module System documentation](https://nixos.org/manual/nixos/stable/#sec-writing-modules).
