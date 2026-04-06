"""
Tests for flake.nix changes and overall repository structure changes in this PR.

Covers:
- flake.nix: directory path typo fix (desktop-enviroment -> desktop-environment)
- desktop-environment/ directory (renamed from desktop-enviroment/)
- Presence of wall-e host in the repository layout

These tests validate the file-system layout and flake.nix source as text.
"""

import os
import pytest

REPO_ROOT = os.path.join(os.path.dirname(__file__), "..")
FLAKE_NIX = os.path.join(REPO_ROOT, "flake.nix")


@pytest.fixture(scope="module")
def flake_src():
    with open(FLAKE_NIX) as f:
        return f.read()


# ── flake.nix directory path fix ────────────────────────────────────────────

class TestFlakeNixDirectoryPath:
    """
    The PR fixed the typo 'desktop-enviroment' (missing 'n') to
    'desktop-environment' in flake.nix's import-tree call.
    """

    def test_correct_directory_name_in_import_tree(self, flake_src):
        assert "./desktop-environment" in flake_src, (
            "flake.nix must reference './desktop-environment' (correct spelling)"
        )

    def test_no_typo_directory_in_import_tree(self, flake_src):
        assert "./desktop-enviroment" not in flake_src, (
            "flake.nix must not reference './desktop-enviroment' (typo with missing 'n')"
        )

    def test_import_tree_match_uses_correct_path(self, flake_src):
        """The full import-tree.match call must use the corrected path."""
        # The Nix source contains the literal text: ".*/[^/]+/default\\.nix" ./desktop-environment
        # which in Python string representation requires 4 backslashes to match 2.
        assert 'import-tree.match ".*/[^/]+/default\\\\.nix" ./desktop-environment' in flake_src


# ── directory structure ──────────────────────────────────────────────────────

class TestDesktopEnvironmentDirectory:
    """
    The desktop-enviroment/ directory was renamed to desktop-environment/.
    """

    def test_correct_directory_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment")
        assert os.path.isdir(path), (
            "desktop-environment/ directory must exist (correctly spelled)"
        )

    def test_typo_directory_does_not_exist(self):
        path = os.path.join(REPO_ROOT, "desktop-enviroment")
        assert not os.path.isdir(path), (
            "desktop-enviroment/ (typo) directory must not exist; it was renamed"
        )

    def test_gnome_subdir_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "GNOME")
        assert os.path.isdir(path)

    def test_plasma_subdir_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "Plasma")
        assert os.path.isdir(path)

    def test_gnome_default_nix_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "GNOME", "default.nix")
        assert os.path.isfile(path)

    def test_plasma_default_nix_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "Plasma", "default.nix")
        assert os.path.isfile(path)

    def test_readme_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "README.md")
        assert os.path.isfile(path)

    def test_keybinds_exists(self):
        path = os.path.join(REPO_ROOT, "desktop-environment", "keybinds.md")
        assert os.path.isfile(path)


# ── wall-e host directory ────────────────────────────────────────────────────

class TestWallEHostDirectory:
    """The wall-e host directory was added in this PR."""

    def test_wall_e_directory_exists(self):
        path = os.path.join(REPO_ROOT, "hosts", "wall-e")
        assert os.path.isdir(path), "hosts/wall-e/ directory must exist"

    def test_wall_e_default_nix_exists(self):
        path = os.path.join(REPO_ROOT, "hosts", "wall-e", "default.nix")
        assert os.path.isfile(path), "hosts/wall-e/default.nix must exist"

    def test_wall_e_readme_exists(self):
        path = os.path.join(REPO_ROOT, "hosts", "wall-e", "README.md")
        assert os.path.isfile(path), "hosts/wall-e/README.md must exist"


# ── btop and fastfetch wrapper directories ──────────────────────────────────

class TestNewWrapperDirectories:
    """New wrapper directories were added in this PR."""

    def test_btop_wrapper_directory_exists(self):
        path = os.path.join(REPO_ROOT, "packages", "wrappers", "btop")
        assert os.path.isdir(path)

    def test_btop_wrapper_default_nix_exists(self):
        path = os.path.join(REPO_ROOT, "packages", "wrappers", "btop", "default.nix")
        assert os.path.isfile(path)

    def test_fastfetch_wrapper_directory_exists(self):
        path = os.path.join(REPO_ROOT, "packages", "wrappers", "fastfetch")
        assert os.path.isdir(path)

    def test_fastfetch_wrapper_default_nix_exists(self):
        path = os.path.join(REPO_ROOT, "packages", "wrappers", "fastfetch", "default.nix")
        assert os.path.isfile(path)


# ── flake.nix overall structure ──────────────────────────────────────────────

class TestFlakeNixStructure:
    """Validate that flake.nix retains essential structure after the path fix."""

    def test_imports_modules(self, flake_src):
        assert "import-tree ./modules" in flake_src

    def test_imports_packages(self, flake_src):
        assert "import-tree ./packages" in flake_src

    def test_imports_hosts(self, flake_src):
        assert "import-tree" in flake_src and "./hosts" in flake_src

    def test_imports_devshells(self, flake_src):
        assert "./devShells" in flake_src

    def test_imports_nix_wrapper_modules(self, flake_src):
        assert "nix-wrapper-modules.flakeModules.wrappers" in flake_src

    def test_flake_parts_used(self, flake_src):
        assert "flake-parts" in flake_src

    def test_supports_x86_64_linux(self, flake_src):
        assert "x86_64-linux" in flake_src

    def test_supports_aarch64_linux(self, flake_src):
        assert "aarch64-linux" in flake_src

    def test_git_hooks_nix_imported(self, flake_src):
        assert "git-hooks-nix.flakeModule" in flake_src

    def test_nixpkgs_input_present(self, flake_src):
        assert "nixpkgs" in flake_src

    def test_home_manager_input_present(self, flake_src):
        assert "home-manager" in flake_src