{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  ...
}:

buildNpmPackage rec {
  pname = "qml-formatter";
  version = "unstable-2023-03-16";

  src = fetchFromGitHub {
    owner = "AndreOneti";
    repo = "qml-formatter";
    rev = "9dcac31628077416812f7c99b80143905fe0b799";
    hash = "sha256-XvN1XaAFMcTaq3ED0LbKrggFo/lCcG3GCJWuQoHojQw=";
  };

  npmDepsHash = "sha256-tuEfyePwlOy2/aaaaabqJskO6IowvAP4DWg8xSZwbJw=";

  npmPackFlags = [ "--ignore-scripts" ];

  NODE_OPTIONS = "--openssl-legacy-provider";

  meta = with lib; {
    description = "Formatter, definition and autocomplete for QML language";
    homepage = "https://github.com/AndreOneti/qml-formatter";
    changelog = "https://github.com/AndreOneti/qml-formatter/blob/${src.rev}/ChangeLog.md";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "qml-formatter";
    platforms = platforms.all;
  };
}
