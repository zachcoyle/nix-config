{ stdenvNoCC, fetchzip, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "galatia-sil";
  version = "2.1";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/galatia/GalatiaSIL-${version}-web.zip";
    sha256 = "sha256-7yep77f5j5Y97hKAcobckIj5mF9r2SSAZvNg3Xv6RYg=";
  };

  dontPatch = true;
  dontConfigure = true;
  dontBuild = true;
  doCheck = false;
  dontFixup = true;

  installPhase = ''
    runHook preInstall
    install -Dm644 -t $out/share/fonts/truetype/ ./*.ttf
    runHook postInstall
  '';
}
