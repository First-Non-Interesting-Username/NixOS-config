This convention applies to all documents in this repository, including contributor-related, such as [CONTRIBUTING.md](./CONTRIBUTING.md).

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this document are to be interpreted as described in [RFC 2119](https://www.ietf.org/rfc/rfc2119.txt).

## Table of Contents

- [Conventions](#conventions)
  - [Table of Contents](#table-of-contents)
  - [General Guidelines](#general-guidelines)
  - [Markdown Formatting](#markdown-formatting)
  - [Line Types](#line-types)
    - [Code Blocks](#code-blocks)
  - [Function Tags](#function-tags)
  - [Module Documentation](#module-documentation)
    - [Document Structure](#document-structure)
    - [Special Args](#special-args)
    - [Secrets](#secrets)
    - [Status Tags](#status-tags)
    - [IMPERATIVE Modules](#imperative-modules)
    - [Section Dividers](#section-dividers)
    - [Feature Bullets](#feature-bullets)
  - [Table of Contents Rules](#table-of-contents-rules)

---

## General Guidelines

- All documents in this repository MUST be written in simple present tense.
- Sentences MUST be written in active voice.
- Simple English SHOULD be used. Avoid jargon and complex vocabulary where possible.
- Each line of text SHOULD contain only one sentence and MUST end with either period or colon.
- Bullet lists SHOULD be used where applicable.
- Text inside parentheses counts as comments in text lines.
- Package names MUST start with capital letters.

---

## Markdown Formatting

- Docs MUST be in markdown.
- Headings MUST NOT end with punctuation mark.
- Code MUST be inside code blocks with syntax highlighting corresponding to the language it is written in.
- Docs MUST be formatted using the Prettier formatter.

---

## Line Types

There are 4 types of line: Text, Heading, Code and Mixed.

- Text: The line is fully text. It doesn't have code or headings.
- Heading: The line starts with one or multiple hashtags, which markdown formatting changes to heading.
- Code: The line is inside code block or is starting or ending a code block.
- Mixed: Text or Heading lines that contain a code block.
  Each of those follow their own rules, as defined below.

### Code Blocks

- Mixed lines MUST follow Heading or Text rules, depending if they start with hashtag or not.

---

## Function Tags

- Functions with `WIP` in the description are in work. They are prone to change and can be unstable but they're ready for use.
- Functions with `TBD` in the description are yet to be ready to be used. Using them is not supported and I won't provide support for them.
- Functions with `PERSONAL` in the description are meant only for my personal use. They're not supported, unexpected behaviour should be expected (yes, this is a pun).
- Functions with `IMPERATIVE` in the description require some imperative configuration. The configuration required for them MUST be described above the list of the features of the module.

---

## Module Documentation

Each NixOS module requires a `README.md` in its directory.

### Document Structure

```md
# Category

## self.nixosModules.MODULE_NAME

[Status tag]

Special args: username, hostname, ...

Secrets: secret_name, ...

[IMPERATIVE instructions]

###

- Feature bullet 1
- Feature bullet 2
- Feature bullet 3
```

#### Special Args

When creating or changing a module, you MUST mention all required special args, except for `username` and `impermanence`.
Special args are passed to the module via the flake and are required for the module to function.
Common special args include:

- `username` - Required for almost all modules to set up user-specific configuration.
- `hostname` - Required for modules that need host-specific configuration or secrets.
- `impermanence` - Optional, enables persistence configuration.

#### Secrets

If a module uses secrets via sops, you MUST document them.
List all secrets the module requires, for example:

- `github_pat` - GitHub Personal Access Token for GitHub CLI authentication.
- `ssh_keys/private/${hostname}` - SSH private key for the host.
- `sudo_password/${hostname}` - Hashed password for sudo access.

### Status Tags

Status tags MUST appear before the feature list:

- `WIP` - Work in progress, prone to change.
- `TBD` - Yet to be ready to be used.
- `PERSONAL` - Personal use only.
- `IMPERATIVE:` - Requires manual configuration.

### IMPERATIVE Modules

When `IMPERATIVE:` is used, the required manual steps MUST be listed after the tag before the feature bullets.

### Section Dividers

Use `###` with no text after to separate distinct groups of features within the same module.

### Feature Bullets

- Features MUST be in bullet lists using hyphens.
- Bullets MUST start with a verb in simple present tense.
- Bullets MUST use active voice.

---

## Table of Contents Rules

All documents with more than 3 sections MUST have a Table of Contents.

The Table of Contents MUST:

- Be placed before the first heading.
- Use a nested bullet list.
- Link to all ## headings using anchor links.
- Use the heading text as the link text.
