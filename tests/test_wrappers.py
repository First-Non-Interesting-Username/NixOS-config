"""
Tests for package wrapper configurations.

Covers PR changes to:
- packages/wrappers/btop/default.nix    (new file)
- packages/wrappers/fastfetch/default.nix (new file)
- packages/wrappers/foot/default.nix    (refactored to use `name` variable)

Validates the Nix source as text, checking the structural patterns and
configuration values that were added or changed in this PR.
"""

import os
import re
import pytest

WRAPPERS_DIR = os.path.join(os.path.dirname(__file__), "..", "packages", "wrappers")


def read_wrapper(name: str) -> str:
    path = os.path.join(WRAPPERS_DIR, name, "default.nix")
    with open(path) as f:
        return f.read()


@pytest.fixture(scope="module")
def btop_src():
    return read_wrapper("btop")


@pytest.fixture(scope="module")
def fastfetch_src():
    return read_wrapper("fastfetch")


@pytest.fixture(scope="module")
def foot_src():
    return read_wrapper("foot")


# ── btop wrapper ────────────────────────────────────────────────────────────

class TestBtopWrapper:
    """btop/default.nix was added in this PR."""

    def test_file_exists(self):
        path = os.path.join(WRAPPERS_DIR, "btop", "default.nix")
        assert os.path.isfile(path), "btop/default.nix must exist"

    def test_uses_name_variable(self, btop_src):
        assert 'name = "btop"' in btop_src, (
            'btop wrapper must define name = "btop"'
        )

    def test_perSystem_enables_package(self, btop_src):
        assert "wrappers.packages.${name} = true" in btop_src, (
            "perSystem block must enable the wrapper via wrappers.packages.${name}"
        )

    def test_imports_wlib_wrapper_module(self, btop_src):
        assert "wlib.wrapperModules.${name}" in btop_src, (
            "wrapper must import wlib.wrapperModules.${name}"
        )

    def test_color_theme_is_gruvbox_dark(self, btop_src):
        assert 'color_theme = "gruvbox_dark"' in btop_src, (
            "btop must set color_theme to gruvbox_dark"
        )

    def test_vim_keys_enabled(self, btop_src):
        assert "vim_keys = true" in btop_src, (
            "btop must enable vim_keys"
        )

    def test_settings_block_present(self, btop_src):
        assert "settings = {" in btop_src, "btop wrapper must have a settings block"

    def test_has_flake_wrappers_attribute(self, btop_src):
        assert "flake.wrappers.${name}" in btop_src, (
            "btop must expose flake.wrappers.${name}"
        )

    def test_no_hardcoded_name_in_attribute_paths(self, btop_src):
        """
        All attribute references must use ${name}, not the hardcoded string 'btop',
        ensuring the name variable drives the configuration.
        """
        # wrappers.packages.btop and flake.wrappers.btop should NOT appear
        assert "wrappers.packages.btop" not in btop_src
        assert "flake.wrappers.btop " not in btop_src

    def test_vim_keys_value_is_boolean_true(self, btop_src):
        # In Nix, true is the boolean literal (not "true" string)
        match = re.search(r'vim_keys\s*=\s*(\S+)', btop_src)
        assert match is not None, "vim_keys setting not found"
        assert match.group(1).rstrip(";") == "true", (
            "vim_keys must be set to Nix boolean true, not a string"
        )


# ── fastfetch wrapper ────────────────────────────────────────────────────────

class TestFastfetchWrapper:
    """fastfetch/default.nix was added in this PR."""

    def test_file_exists(self):
        path = os.path.join(WRAPPERS_DIR, "fastfetch", "default.nix")
        assert os.path.isfile(path), "fastfetch/default.nix must exist"

    def test_uses_name_variable(self, fastfetch_src):
        assert 'name = "fastfetch"' in fastfetch_src

    def test_perSystem_enables_package(self, fastfetch_src):
        assert "wrappers.packages.${name} = true" in fastfetch_src

    def test_imports_wlib_wrapper_module(self, fastfetch_src):
        assert "wlib.wrapperModules.${name}" in fastfetch_src

    def test_has_flake_wrappers_attribute(self, fastfetch_src):
        assert "flake.wrappers.${name}" in fastfetch_src

    def test_display_separator_set(self, fastfetch_src):
        assert 'separator = "  "' in fastfetch_src, (
            "fastfetch must set display.separator"
        )

    def test_display_color_is_blue(self, fastfetch_src):
        assert 'color = "blue"' in fastfetch_src, (
            "fastfetch display color must be blue"
        )

    def test_modules_list_present(self, fastfetch_src):
        assert "modules = [" in fastfetch_src, (
            "fastfetch must define a modules list"
        )

    def test_title_module_present(self, fastfetch_src):
        assert 'type = "title"' in fastfetch_src

    def test_os_module_present(self, fastfetch_src):
        assert 'type = "os"' in fastfetch_src

    def test_kernel_module_present(self, fastfetch_src):
        assert 'type = "kernel"' in fastfetch_src

    def test_uptime_module_present(self, fastfetch_src):
        assert 'type = "uptime"' in fastfetch_src

    def test_cpu_module_present(self, fastfetch_src):
        assert 'type = "cpu"' in fastfetch_src

    def test_gpu_module_present(self, fastfetch_src):
        assert 'type = "gpu"' in fastfetch_src

    def test_memory_module_present(self, fastfetch_src):
        assert 'type = "memory"' in fastfetch_src

    def test_memory_format_set(self, fastfetch_src):
        assert 'format = "{1} / {2}"' in fastfetch_src, (
            "memory module must show used/total format"
        )

    def test_disk_module_present(self, fastfetch_src):
        assert 'type = "disk"' in fastfetch_src

    def test_disk_format_includes_percentage(self, fastfetch_src):
        assert '"{1} / {2} ({9})"' in fastfetch_src, (
            "disk format must include percentage field {9}"
        )

    def test_shell_module_present(self, fastfetch_src):
        assert 'type = "shell"' in fastfetch_src

    def test_terminal_module_present(self, fastfetch_src):
        assert 'type = "terminal"' in fastfetch_src

    def test_packages_module_present(self, fastfetch_src):
        assert 'type = "packages"' in fastfetch_src

    def test_break_separators_present(self, fastfetch_src):
        assert '"break"' in fastfetch_src, (
            "fastfetch modules list must include break separators"
        )

    def test_title_color_user_is_blue(self, fastfetch_src):
        assert 'user = "blue"' in fastfetch_src

    def test_title_color_host_is_blue(self, fastfetch_src):
        assert 'host = "blue"' in fastfetch_src

    def test_title_color_at_is_white(self, fastfetch_src):
        assert 'at = "white"' in fastfetch_src

    def test_no_hardcoded_name_in_attribute_paths(self, fastfetch_src):
        assert "wrappers.packages.fastfetch" not in fastfetch_src
        assert "flake.wrappers.fastfetch " not in fastfetch_src

    def test_de_module_present(self, fastfetch_src):
        assert 'type = "de"' in fastfetch_src

    def test_wm_module_present(self, fastfetch_src):
        assert 'type = "wm"' in fastfetch_src

    def test_board_module_present(self, fastfetch_src):
        assert 'type = "board"' in fastfetch_src

    def test_display_module_present(self, fastfetch_src):
        assert 'type = "display"' in fastfetch_src

    def test_settings_block_present(self, fastfetch_src):
        assert "settings = {" in fastfetch_src


# ── foot wrapper (refactored) ─────────────────────────────────────────────────

class TestFootWrapper:
    """
    foot/default.nix was refactored in this PR to use a `name` variable
    instead of hardcoded string literals.
    """

    def test_uses_name_variable_declaration(self, foot_src):
        assert 'name = "foot"' in foot_src, (
            'foot wrapper must declare name = "foot" let-binding'
        )

    def test_perSystem_uses_name_variable(self, foot_src):
        assert "wrappers.packages.${name} = true" in foot_src, (
            "perSystem must reference ${name} instead of hardcoded 'foot'"
        )

    def test_flake_wrappers_uses_name_variable(self, foot_src):
        assert "flake.wrappers.${name}" in foot_src, (
            "flake.wrappers must reference ${name} instead of hardcoded 'foot'"
        )

    def test_imports_uses_name_variable(self, foot_src):
        assert "wlib.wrapperModules.${name}" in foot_src, (
            "imports must reference wlib.wrapperModules.${name}"
        )

    def test_no_hardcoded_foot_in_attribute_paths(self, foot_src):
        """After the refactor, 'foot' must not appear as a hardcoded attr name."""
        assert "wrappers.packages.foot" not in foot_src, (
            "wrappers.packages must use ${name}, not hardcoded 'foot'"
        )
        assert "flake.wrappers.foot " not in foot_src, (
            "flake.wrappers must use ${name}, not hardcoded 'foot'"
        )
        assert "wrapperModules.foot" not in foot_src, (
            "wrapperModules must use ${name}, not hardcoded 'foot'"
        )

    def test_settings_preserved_after_refactor(self, foot_src):
        """Core settings must remain intact after the refactoring."""
        assert "settings = {" in foot_src
        assert "JetBrainsMono Nerd Font" in foot_src
        assert "gruvbox-dark" in foot_src

    def test_extra_packages_preserved(self, foot_src):
        assert "nerd-fonts.jetbrains-mono" in foot_src

    def test_csd_size_zero(self, foot_src):
        assert "size = 0" in foot_src, "CSD must be disabled (size = 0)"

    def test_bell_all_disabled(self, foot_src):
        assert "urgent = false" in foot_src
        assert "notify = false" in foot_src
        assert "visual = false" in foot_src

    def test_cursor_style_beam(self, foot_src):
        assert 'style = "beam"' in foot_src

    def test_cursor_blinking_enabled(self, foot_src):
        assert "blink = true" in foot_src

    def test_scrollback_multiplier_set(self, foot_src):
        assert "multiplier = 5.0" in foot_src


# ── cross-wrapper consistency ────────────────────────────────────────────────

class TestWrapperConsistency:
    """All wrappers should follow the same structural pattern."""

    WRAPPER_NAMES = ["btop", "fastfetch", "foot"]

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_wrapper_file_exists(self, wrapper_name):
        path = os.path.join(WRAPPERS_DIR, wrapper_name, "default.nix")
        assert os.path.isfile(path)

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_uses_name_let_binding(self, wrapper_name):
        src = read_wrapper(wrapper_name)
        assert f'name = "{wrapper_name}"' in src, (
            f"{wrapper_name}/default.nix must declare name = \"{wrapper_name}\" as a let binding"
        )

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_perSystem_enables_via_name(self, wrapper_name):
        src = read_wrapper(wrapper_name)
        assert "wrappers.packages.${name} = true" in src

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_imports_wlib_module_via_name(self, wrapper_name):
        src = read_wrapper(wrapper_name)
        assert "wlib.wrapperModules.${name}" in src

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_flake_wrappers_exposed_via_name(self, wrapper_name):
        src = read_wrapper(wrapper_name)
        assert "flake.wrappers.${name}" in src

    @pytest.mark.parametrize("wrapper_name", WRAPPER_NAMES)
    def test_settings_block_present(self, wrapper_name):
        src = read_wrapper(wrapper_name)
        assert "settings = {" in src, (
            f"{wrapper_name}/default.nix must have a settings block"
        )