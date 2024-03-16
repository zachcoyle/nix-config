{
  pkgs,
  stdenv,
  fetchFromGitHub,
  AppKit,
  CoreGraphics,
  CoreVideo,
  SkyLight,
  ...
}:
stdenv.mkDerivation {
  pname = "jankyborders";
  version = "unstable";
  src = fetchFromGitHub {
    owner = "FelixKratz";
    repo = "JankyBorders";
    rev = "ecd8a397b729e2e172fd8f9c42bb1705285360bf";
    sha256 = "sha256-X7mMErjfWDpfEBj3xP/kOnA27NfVs363nxG2yqpCnzQ=";
  };

  buildInputs = [
    AppKit
    CoreGraphics
    CoreVideo
    SkyLight
  ];

  installPhase = ''
    runHook preInstall

    ${pkgs.lsd}/bin/lsd --tree -a

    mkdir -p $out/bin
    cp ./bin/borders $out/bin/borders

    runHook postInstall
  '';
}
