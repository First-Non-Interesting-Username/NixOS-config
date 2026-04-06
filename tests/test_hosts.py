"""
Tests for host configurations changed in this PR.

Covers:
- hosts/wall-e/default.nix (new file): terminal-only ISO host
- hosts/john/default.nix (modified): secretless-git module removed
- hosts/wall-e/README.md (new file)

Validates Nix source as text for structural and configuration correctness.
"""

import os
import re
import pytest

HOSTS_DIR = os.path.join(os.path.dirname(__file__), "..", "hosts")


def read_host(hostname: str, filename: str = "default.nix") -> str:
    path = os.path.join(HOSTS_DIR, hostname, filename)
    with open(path) as f:
        return f.read()


@pytest.fixture(scope="module")
def wall_e_src():
    return read_host("wall-e")


@pytest.fixture(scope="module")
def john_src():
    return read_host("john")


# ── wall-e host (new) ────────────────────────────────────────────────────────

class TestWallEHost:
    """hosts/wall-e/default.nix was added in this PR as a CLI-only ISO host."""

    def test_default_nix_exists(self):
        path = os.path.join(HOSTS_DIR, "wall-e", "default.nix")
        assert os.path.isfile(path), "wall-e/default.nix must exist"

    def test_readme_exists(self):
        path = os.path.join(HOSTS_DIR, "wall-e", "README.md")
        assert os.path.isfile(path), "wall-e/README.md must exist"

    def test_hostname_is_wall_e(self, wall_e_src):
        assert 'Hostname = "wall-e"' in wall_e_src, (
            "wall-e host must set Hostname = \"wall-e\""
        )

    def test_username_is_nixos(self, wall_e_src):
        assert 'Username = "nixos"' in wall_e_src, (
            "wall-e host must set Username = \"nixos\" (standard ISO username)"
        )

    def test_system_is_x86_64_linux(self, wall_e_src):
        assert 'system = "x86_64-linux"' in wall_e_src

    def test_impermanence_disabled(self, wall_e_src):
        assert "impermanence = false" in wall_e_src, (
            "ISO hosts must have impermanence disabled"
        )

    def test_uses_iso_terminal_module(self, wall_e_src):
        assert "iso-terminal" in wall_e_src, (
            "wall-e must use iso-terminal module (not iso-graphical)"
        )

    def test_does_not_use_iso_graphical_module(self, wall_e_src):
        assert "iso-graphical" not in wall_e_src, (
            "wall-e is a CLI-only ISO and must not include iso-graphical"
        )

    def test_uses_secretless_git(self, wall_e_src):
        assert "secretless-git" in wall_e_src, (
            "wall-e (an ISO) must use secretless-git, not the secrets-based git module"
        )

    def test_uses_secretless_user(self, wall_e_src):
        assert "secretless-user" in wall_e_src, (
            "wall-e (an ISO) must use secretless-user"
        )

    def test_uses_shell_module(self, wall_e_src):
        assert "self.nixosModules.shell" in wall_e_src

    def test_uses_home_manager_module(self, wall_e_src):
        assert "home-manager" in wall_e_src

    def test_uses_locale_module(self, wall_e_src):
        assert "self.nixosModules.locale" in wall_e_src

    def test_uses_networking_minimal_module(self, wall_e_src):
        assert "networking-minimal" in wall_e_src, (
            "ISO hosts must use networking-minimal (not networking-desktop/server)"
        )

    def test_uses_power_module(self, wall_e_src):
        assert "self.nixosModules.power" in wall_e_src

    def test_uses_nix_module(self, wall_e_src):
        assert "self.nixosModules.nix" in wall_e_src

    def test_exports_package_as_iso_image(self, wall_e_src):
        assert "config.system.build.isoImage" in wall_e_src, (
            "wall-e must export isoImage as the package output"
        )

    def test_package_exported_for_x86_64(self, wall_e_src):
        assert "flake.packages.x86_64-linux" in wall_e_src

    def test_package_name_matches_hostname(self, wall_e_src):
        assert 'flake.packages.x86_64-linux.${Hostname}' in wall_e_src or \
               'packages.x86_64-linux."wall-e"' in wall_e_src or \
               "packages.x86_64-linux.wall-e" in wall_e_src, (
            "Package export must use the Hostname variable"
        )

    def test_git_name_is_iso_user(self, wall_e_src):
        assert 'gitName = "ISO-User"' in wall_e_src, (
            "ISO hosts use a generic gitName"
        )

    def test_git_email_is_iso_local(self, wall_e_src):
        assert "iso@nixos.local" in wall_e_src

    def test_home_manager_uses_global_pkgs(self, wall_e_src):
        assert "home-manager.useGlobalPkgs = true" in wall_e_src

    def test_home_manager_uses_user_packages(self, wall_e_src):
        assert "home-manager.useUserPackages = true" in wall_e_src

    def test_resolution_configured(self, wall_e_src):
        assert "width = 1920" in wall_e_src
        assert "height = 1080" in wall_e_src

    def test_uses_ssh_debug_module(self, wall_e_src):
        assert "ssh-debug" in wall_e_src

    def test_uses_user_debug_module(self, wall_e_src):
        assert "user-debug" in wall_e_src

    def test_uses_input_module(self, wall_e_src):
        assert "self.nixosModules.input" in wall_e_src

    def test_does_not_use_gnome_module(self, wall_e_src):
        """CLI-only ISO should not include a desktop environment."""
        assert "self.nixosModules.GNOME" not in wall_e_src

    def test_does_not_use_audio_module(self, wall_e_src):
        """CLI-only ISO should not include audio."""
        assert "self.nixosModules.audio" not in wall_e_src

    def test_flake_outputs_nixos_configuration(self, wall_e_src):
        assert "flake.nixosConfigurations" in wall_e_src


# ── wall-e vs john consistency ───────────────────────────────────────────────

class TestWallEVsJohnConsistency:
    """
    wall-e and john are both ISO hosts. They should share common patterns.
    """

    def test_both_have_same_username(self, wall_e_src, john_src):
        assert 'Username = "nixos"' in wall_e_src
        assert 'Username = "nixos"' in john_src

    def test_both_disable_impermanence(self, wall_e_src, john_src):
        assert "impermanence = false" in wall_e_src
        assert "impermanence = false" in john_src

    def test_both_use_x86_64_linux(self, wall_e_src, john_src):
        assert 'system = "x86_64-linux"' in wall_e_src
        assert 'system = "x86_64-linux"' in john_src

    def test_both_export_iso_image(self, wall_e_src, john_src):
        assert "config.system.build.isoImage" in wall_e_src
        assert "config.system.build.isoImage" in john_src

    def test_both_use_secretless_user(self, wall_e_src, john_src):
        assert "secretless-user" in wall_e_src
        assert "secretless-user" in john_src

    def test_both_use_shell_module(self, wall_e_src, john_src):
        assert "self.nixosModules.shell" in wall_e_src
        assert "self.nixosModules.shell" in john_src

    def test_both_use_home_manager(self, wall_e_src, john_src):
        assert "home-manager" in wall_e_src
        assert "home-manager" in john_src

    def test_both_use_git_iso_user_name(self, wall_e_src, john_src):
        assert 'gitName = "ISO-User"' in wall_e_src
        assert 'gitName = "ISO-User"' in john_src

    def test_john_uses_secretless_git(self, john_src):
        """
        john (graphical ISO) includes secretless-git for anonymous git use.
        """
        assert "secretless-git" in john_src, (
            "john must include the secretless-git module"
        )

    def test_wall_e_has_secretless_git(self, wall_e_src):
        assert "secretless-git" in wall_e_src

    def test_wall_e_uses_terminal_not_graphical_iso(self, wall_e_src, john_src):
        assert "iso-terminal" in wall_e_src
        assert "iso-graphical" in john_src

    def test_both_have_ssh_debug(self, wall_e_src, john_src):
        assert "ssh-debug" in wall_e_src
        assert "ssh-debug" in john_src


# ── shell module changes ─────────────────────────────────────────────────────

class TestShellModule:
    """
    modules/development/shell.nix was modified:
    - Removed inline btop and fastfetch program configurations
    - Added self.packages references for btop and fastfetch
    """

    SHELL_NIX = os.path.join(
        os.path.dirname(__file__), "..", "modules", "development", "shell.nix"
    )

    @pytest.fixture(scope="class")
    def shell_src(self):
        with open(self.SHELL_NIX) as f:
            return f.read()

    def test_shell_module_exists(self):
        assert os.path.isfile(self.SHELL_NIX)

    def test_btop_installed_via_self_packages(self, shell_src):
        assert "self.packages.${pkgs.stdenv.hostPlatform.system}.btop" in shell_src, (
            "btop must be installed via self.packages (wrapper), not programs.btop.enable"
        )

    def test_fastfetch_installed_via_self_packages(self, shell_src):
        assert "self.packages.${pkgs.stdenv.hostPlatform.system}.fastfetch" in shell_src, (
            "fastfetch must be installed via self.packages (wrapper), not inline config"
        )

    def test_no_inline_btop_program_config(self, shell_src):
        assert "btop.enable = true" not in shell_src, (
            "Inline programs.btop.enable must be removed; btop is now a wrapper package"
        )

    def test_no_inline_fastfetch_settings(self, shell_src):
        # The old config had fastfetch with its settings inline in programs block
        assert "fastfetch = {" not in shell_src, (
            "Inline fastfetch program block must be removed; fastfetch is now a wrapper package"
        )

    def test_no_inline_fastfetch_modules_list(self, shell_src):
        # Verify the inline modules list (moved to wrapper) is gone from shell.nix
        # The old code had modules = [ { type = "title"; ... } ... ] inline
        # Count occurrences - if fastfetch is gone, we should not have these module types
        # inside a fastfetch configuration block in shell.nix
        # We check there's no `type = "title"` which was part of the fastfetch inline config
        assert 'type = "title"' not in shell_src, (
            "Inline fastfetch module definitions must be removed from shell.nix"
        )

    def test_self_attribute_is_imported(self, shell_src):
        """shell.nix must accept `self` as an argument to reference self.packages."""
        assert "self," in shell_src or "self\n" in shell_src or "self }" in shell_src, (
            "shell.nix must accept `self` as a flake-parts argument"
        )

    def test_home_packages_include_ripgrep(self, shell_src):
        """Other packages must remain in home.packages."""
        assert "ripgrep" in shell_src

    def test_home_packages_include_trash_cli(self, shell_src):
        assert "trash-cli" in shell_src

    def test_fastfetch_called_in_zsh_init(self, shell_src):
        """fastfetch should still be invoked in zsh initContent."""
        assert "fastfetch" in shell_src