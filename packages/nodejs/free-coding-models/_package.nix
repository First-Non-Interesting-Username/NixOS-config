{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "free-coding-models";
  version = "unstable-2026";

  src = fetchFromGitHub {
    owner = "vava-nessa";
    repo = "free-coding-models";
    rev = "f810dfc3d021a43efa554cd2d79c72a55be26571";
    hash = "sha256-JX45l8wbXS/FX16OsCjG9BnmSzC0W9iHyWn7ONZUjZE=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-9yQLGKitdMDVCWncYHvvj8fb1FCS5KtQ9+OKcViGApM=";

  meta = {
    description = "Find the fastest free coding LLM models in seconds";
    homepage = "https://github.com/vava-nessa/free-coding-models";
    license = lib.licenses.mit;
    mainProgram = "free-coding-models";
  };
}
