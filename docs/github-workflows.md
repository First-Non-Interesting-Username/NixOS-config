# Table of Contents

- [Table of Contents](#table-of-contents)
- [Workflows Reference Table](#workflows-reference-table)
- [Triggering Workflows](#triggering-workflows)
  - [Slash Commands](#slash-commands)
  - [Manual Dispatch](#manual-dispatch)
- [Workflow Descriptions](#workflow-descriptions)
- [Adding new workflows](#adding-new-workflows)
- [Workflow Secrets](#workflow-secrets)

# Workflows Reference Table

| Workflow                   | Name                          | Trigger                  | Description                                                        |
| :------------------------- | :---------------------------- | :----------------------- | :----------------------------------------------------------------- |
| `flake-build.yaml`         | Flake build                   | Schedule, Dispatch, PR   | Builds all NixOS configurations and packages.                      |
| `flake-check.yaml`         | Flake check                   | Push, Workflow Call      | Runs `nix flake check` to validate the flake.                      |
| `flake-update.yaml`        | Update flake.lock             | Schedule, Dispatch       | Biweekly update of `flake.lock` via PR.                            |
| `opencode.yaml`            | opencode                      | Comment                  | LLM assistant integration for Issues and PRs.                      |
| `release.yaml`             | Build ISOs and create release | Dispatch                 | Builds ISOs, uploads to SourceForge, and creates a GitHub release. |
| `set-merge-message.yaml`   | Set Merge Commit Message      | PR                       | Sets PR title based on the branch name.                            |
| `slash-dispatch.yaml`      | Slash Command Dispatch        | Comment                  | Dispatches `/test`, `/build`, `/rebuild` commands.                 |
| `slash-processor.yaml`     | Slash Command Processor       | Dispatch                 | Processes dispatched slash commands.                               |
| `update-module-list.yaml`  | Update Module List            | Push, Dispatch, Schedule | Updates the `docs/module-list.md` file.                            |
| `update-package-list.yaml` | Update Package List           | Push, Dispatch, Schedule | Updates the `docs/package-list.md` file.                           |
| `update-packages.yaml`     | Update packages               | Schedule, Dispatch       | Updates custom packages via `nix-update` and creates PRs.          |
| `year-copyright.yaml`      | Update Copyright Year         | Schedule, Dispatch       | Annual update of the copyright year in the LICENSE file.           |

# Triggering Workflows

## Slash Commands

Some workflows can be triggered by commenting on an Issue or Pull Request:

- `/test`: Triggers a test build of the changes.
- `/build`: Triggers a full build.
- `/rebuild`: Forces a rebuild of targets.
- `/pull`: Pulls the latest changes for the PR.
- `/merge`: Merges the current PR.
- `/close`: Closes the current Issue or PR.
- `/oc` or `/opencode`: Triggers the OpenCode LLM assistant.

## Manual Dispatch

Most workflows can be manually triggered from the Actions tab in the GitHub repository:

1. Select the workflow from the left sidebar.
2. Click the Run workflow dropdown.
3. (Optional) Provide required inputs like `tag_name` or `ref`.

# Workflow Descriptions

### Flake Build (`flake-build.yaml`)

This workflow is responsible for ensuring that all NixOS configurations and packages defined in the flake are buildable. It runs on a weekly schedule, on every PR to `main`, and can be triggered manually. If a build fails, it automatically creates or updates an issue labeled `ci-failure`.

### Release (`release.yaml`)

Used to create a new release of the NixOS configuration. It builds ISO images for specific hosts (`john` and `wall-e`), generates SHA256 checksums, and uploads the John ISO to SourceForge. It then creates a GitHub release containing the checksums and links to the SourceForge downloads.

### Update Packages (`update-packages.yaml`)

Automatically checks for updates for custom packages defined in the `packages/` directory. It uses `nix-update` and looks for an `updateScript` in the package's `passthru` attributes. If updates are found, it creates a Pull Request.

# Adding new workflows

When adding new workflows to the repository, please follow these guidelines:

1. **Use standard actions**: Prefer `DeterminateSystems/nix-installer-action` for Nix installation and `wimpysworld/nothing-but-nix` for caching and environment setup.
2. **Handle secrets securely**: Reference secrets via `secrets.NAME` and ensure they are documented in the [Workflow Secrets](#workflow-secrets) section.
3. **Triggering**: Include `workflow_dispatch` to allow manual execution during testing.
4. **Permissions**: Follow the principle of least privilege for the `GITHUB_TOKEN`.

# Workflow Secrets

The following secrets are used across various workflows and must be configured in the GitHub repository settings:

| Secret              | Description                                                          |
| :------------------ | :------------------------------------------------------------------- |
| `PAT`               | GitHub Personal Access Token with repo and workflow permissions.     |
| `CACHIX_AUTH_TOKEN` | Auth token for pushing build artifacts to Cachix.                    |
| `SF_USERNAME`       | SourceForge username for uploading ISOs.                             |
| `SSH_PRIVATE`       | SSH private key for SourceForge authentication.                      |
| `NVIDIA_API_KEY`    | API key for the NVIDIA LLM (used by OpenCode).                       |
| `GITHUB_TOKEN`      | Automatically provided by GitHub, but sometimes overridden by `PAT`. |
