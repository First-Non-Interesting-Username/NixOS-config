"""
Tests for the GitHub Actions release workflow (.github/workflows/release.yaml).

Covers changes from PR:
- Matrix strategy added for multi-host builds (john, wall-e)
- Output keys renamed: sha256 -> sha256_john, sha256_wall-e
- Artifact naming uses per-host pattern: checksum-{host}
- ISO naming uses per-host pattern: {safe_name}-{host}.iso
- Release body now documents both john and wall-e hosts
- Artifact download uses pattern matching instead of single artifact
"""

import os
import pytest
import yaml

WORKFLOW_PATH = os.path.join(
    os.path.dirname(__file__), "..", ".github", "workflows", "release.yaml"
)


@pytest.fixture(scope="module")
def workflow():
    with open(WORKFLOW_PATH) as f:
        return yaml.safe_load(f)


@pytest.fixture(scope="module")
def build_job(workflow):
    return workflow["jobs"]["build"]


@pytest.fixture(scope="module")
def release_job(workflow):
    return workflow["jobs"]["release"]


# --- Matrix strategy ---

class TestMatrixStrategy:
    def test_build_job_has_matrix_strategy(self, build_job):
        assert "strategy" in build_job, "build job must have a matrix strategy"

    def test_matrix_contains_host_key(self, build_job):
        matrix = build_job["strategy"]["matrix"]
        assert "host" in matrix, "matrix must define a 'host' key"

    def test_matrix_hosts_include_john(self, build_job):
        hosts = build_job["strategy"]["matrix"]["host"]
        assert "john" in hosts, "matrix must include 'john' host"

    def test_matrix_hosts_include_wall_e(self, build_job):
        hosts = build_job["strategy"]["matrix"]["host"]
        assert "wall-e" in hosts, "matrix must include 'wall-e' host"

    def test_matrix_has_exactly_two_hosts(self, build_job):
        hosts = build_job["strategy"]["matrix"]["host"]
        assert len(hosts) == 2, f"expected 2 hosts in matrix, got {len(hosts)}: {hosts}"

    def test_build_step_uses_matrix_host(self, build_job):
        """The nix build command must reference the matrix host variable."""
        build_steps = build_job["steps"]
        build_step = next(
            (s for s in build_steps if s.get("name") == "Build"), None
        )
        assert build_step is not None, "Build step not found"
        assert "${{ matrix.host }}" in build_step["run"], (
            "Build step run command must use ${{ matrix.host }}"
        )


# --- Build job outputs ---

class TestBuildOutputs:
    def test_output_sha256_john_present(self, build_job):
        outputs = build_job.get("outputs", {})
        assert "sha256_john" in outputs, "build job must output 'sha256_john'"

    def test_output_sha256_wall_e_present(self, build_job):
        outputs = build_job.get("outputs", {})
        assert "sha256_wall-e" in outputs, "build job must output 'sha256_wall-e'"

    def test_output_safe_name_present(self, build_job):
        outputs = build_job.get("outputs", {})
        assert "safe_name" in outputs, "build job must output 'safe_name'"

    def test_output_sha256_john_references_checksum_step(self, build_job):
        output_val = build_job["outputs"]["sha256_john"]
        assert "steps.checksum.outputs.sha256_john" in output_val

    def test_output_sha256_wall_e_references_checksum_step(self, build_job):
        output_val = build_job["outputs"]["sha256_wall-e"]
        assert "steps.checksum.outputs.sha256_wall-e" in output_val

    def test_no_legacy_sha256_output(self, build_job):
        """The old singular 'sha256' output key must not exist."""
        outputs = build_job.get("outputs", {})
        assert "sha256" not in outputs, (
            "Legacy 'sha256' output key must not exist; use sha256_john and sha256_wall-e"
        )

    def test_formatted_issues_output_present(self, build_job):
        outputs = build_job.get("outputs", {})
        assert "formatted_issues" in outputs


# --- Checksum step ---

class TestChecksumStep:
    def _get_checksum_step(self, build_job):
        steps = build_job["steps"]
        step = next(
            (s for s in steps if s.get("id") == "checksum"), None
        )
        assert step is not None, "Step with id='checksum' not found"
        return step

    def test_checksum_step_exists(self, build_job):
        self._get_checksum_step(build_job)

    def test_iso_name_includes_matrix_host(self, build_job):
        step = self._get_checksum_step(build_job)
        assert "${{ matrix.host }}" in step["run"], (
            "ISO naming in checksum step must include matrix.host"
        )

    def test_hash_output_uses_matrix_host_key(self, build_job):
        step = self._get_checksum_step(build_job)
        assert 'sha256_${{ matrix.host }}' in step["run"], (
            "Checksum step must write sha256_{host} to GITHUB_OUTPUT"
        )

    def test_no_legacy_hash_output_key(self, build_job):
        step = self._get_checksum_step(build_job)
        # Old key was 'hash=', new key is 'sha256_{host}='
        assert '"hash=$HASH"' not in step["run"] and "'hash=$HASH'" not in step["run"], (
            "Legacy 'hash=' output key must not exist in checksum step"
        )

    def test_safe_name_written_to_github_output(self, build_job):
        step = self._get_checksum_step(build_job)
        assert "safe_name=" in step["run"]


# --- Upload artifact step ---

class TestUploadArtifact:
    def _get_upload_step(self, build_job):
        steps = build_job["steps"]
        step = next(
            (s for s in steps if "Upload Checksum Artifact" in (s.get("name") or "")),
            None,
        )
        assert step is not None, "Upload Checksum Artifact step not found"
        return step

    def test_artifact_name_includes_matrix_host(self, build_job):
        step = self._get_upload_step(build_job)
        artifact_name = step["with"]["name"]
        assert "${{ matrix.host }}" in artifact_name, (
            "Artifact name must include matrix.host to distinguish per-host artifacts"
        )

    def test_artifact_name_has_checksum_prefix(self, build_job):
        step = self._get_upload_step(build_job)
        artifact_name = step["with"]["name"]
        assert artifact_name.startswith("checksum-"), (
            "Artifact name must start with 'checksum-'"
        )

    def test_artifact_path_includes_matrix_host(self, build_job):
        step = self._get_upload_step(build_job)
        path = step["with"]["path"]
        assert "${{ matrix.host }}" in path, (
            "Artifact path must include matrix.host in the filename"
        )

    def test_no_legacy_artifact_name(self, build_job):
        """Old artifact name was 'checksum-file', it must be gone."""
        step = self._get_upload_step(build_job)
        assert step["with"]["name"] != "checksum-file", (
            "Legacy artifact name 'checksum-file' must not be used"
        )


# --- SCP upload step ---

class TestScpUploadStep:
    def _get_scp_step(self, build_job):
        steps = build_job["steps"]
        step = next(
            (s for s in steps if "Copy file via SSH" in (s.get("name") or "")),
            None,
        )
        assert step is not None, "Copy file via SSH step not found"
        return step

    def test_scp_source_includes_matrix_host(self, build_job):
        step = self._get_scp_step(build_job)
        source = step["with"]["source"]
        assert "${{ matrix.host }}" in source, (
            "SCP source must include matrix.host in filenames"
        )

    def test_scp_source_uses_checksum_step_safe_name(self, build_job):
        step = self._get_scp_step(build_job)
        source = step["with"]["source"]
        assert "steps.checksum.outputs.safe_name" in source, (
            "SCP source must reference steps.checksum.outputs.safe_name"
        )


# --- Release job ---

class TestReleaseJob:
    def test_release_job_needs_build(self, release_job):
        needs = release_job.get("needs", [])
        assert "build" in needs

    def test_download_artifact_uses_pattern(self, release_job):
        steps = release_job["steps"]
        download_step = next(
            (s for s in steps if "Download" in (s.get("name") or "")), None
        )
        assert download_step is not None, "Download step not found in release job"
        pattern = download_step["with"].get("pattern", "")
        assert "checksum-*" in pattern, (
            "Download step must use pattern 'checksum-*' to retrieve all host artifacts"
        )

    def test_download_artifact_merges_multiple(self, release_job):
        steps = release_job["steps"]
        download_step = next(
            (s for s in steps if "Download" in (s.get("name") or "")), None
        )
        assert download_step is not None
        assert download_step["with"].get("merge-multiple") is True, (
            "Download step must set merge-multiple: true"
        )

    def test_no_single_artifact_name_in_download(self, release_job):
        """Old approach used name: checksum-file; new approach uses pattern."""
        steps = release_job["steps"]
        download_step = next(
            (s for s in steps if "Download" in (s.get("name") or "")), None
        )
        assert download_step is not None
        assert "name" not in download_step.get("with", {}), (
            "Download step must not use 'name' key (changed to 'pattern')"
        )

    def test_release_files_uses_glob_pattern(self, release_job):
        steps = release_job["steps"]
        release_step = next(
            (s for s in steps if "Create GitHub Release" in (s.get("name") or "")),
            None,
        )
        assert release_step is not None, "Create GitHub Release step not found"
        files = release_step["with"].get("files", "")
        assert "*.sha256" in files, (
            "Release step must use '*.sha256' glob to include all checksum files"
        )


# --- Release body content ---

class TestReleaseBody:
    def _get_release_body(self, release_job):
        steps = release_job["steps"]
        release_step = next(
            (s for s in steps if "Create GitHub Release" in (s.get("name") or "")),
            None,
        )
        assert release_step is not None
        return release_step["with"]["body"]

    def test_body_mentions_john_host(self, release_job):
        body = self._get_release_body(release_job)
        assert "john" in body.lower(), "Release body must mention the 'john' host"

    def test_body_mentions_wall_e_host(self, release_job):
        body = self._get_release_body(release_job)
        assert "wall-e" in body.lower(), "Release body must mention the 'wall-e' host"

    def test_body_includes_sha256_john_reference(self, release_job):
        body = self._get_release_body(release_job)
        assert "sha256_john" in body, (
            "Release body must reference needs.build.outputs.sha256_john"
        )

    def test_body_includes_sha256_wall_e_reference(self, release_job):
        body = self._get_release_body(release_job)
        assert "sha256_wall-e" in body, (
            "Release body must reference needs.build.outputs.sha256_wall-e"
        )

    def test_body_john_download_link_uses_host_suffix(self, release_job):
        body = self._get_release_body(release_job)
        assert "-john.iso" in body, (
            "John download link must reference ISO with '-john.iso' suffix"
        )

    def test_body_wall_e_download_link_uses_host_suffix(self, release_job):
        body = self._get_release_body(release_job)
        assert "-wall-e.iso" in body, (
            "Wall-E download link must reference ISO with '-wall-e.iso' suffix"
        )

    def test_body_no_legacy_single_sha256(self, release_job):
        """Old body used needs.build.outputs.sha256, must be gone."""
        body = self._get_release_body(release_job)
        assert "outputs.sha256 }}" not in body and "outputs.sha256}}" not in body, (
            "Release body must not reference the old singular 'sha256' output"
        )


# --- Overall workflow structure ---

class TestWorkflowStructure:
    def test_workflow_has_check_job(self, workflow):
        assert "check" in workflow["jobs"]

    def test_workflow_has_build_job(self, workflow):
        assert "build" in workflow["jobs"]

    def test_workflow_has_release_job(self, workflow):
        assert "release" in workflow["jobs"]

    def test_workflow_has_reminder_job(self, workflow):
        assert "reminder" in workflow["jobs"]

    def test_build_needs_check(self, build_job):
        assert "check" in build_job.get("needs", [])

    def test_release_needs_build(self, workflow):
        assert "build" in workflow["jobs"]["release"].get("needs", [])

    def test_workflow_trigger_is_workflow_dispatch(self, workflow):
        # PyYAML 1.1 parses the YAML key `on` as boolean True, not string "on"
        on_key = True if True in workflow else "on"
        assert "workflow_dispatch" in workflow[on_key]

    def test_workflow_dispatch_has_tag_name_input(self, workflow):
        on_key = True if True in workflow else "on"
        inputs = workflow[on_key]["workflow_dispatch"]["inputs"]
        assert "tag_name" in inputs

    def test_workflow_dispatch_has_issue_numbers_input(self, workflow):
        on_key = True if True in workflow else "on"
        inputs = workflow[on_key]["workflow_dispatch"]["inputs"]
        assert "issue_numbers" in inputs