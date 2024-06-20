{ stdenvNoCC, fetchzip, ... }:
stdenvNoCC.mkDerivation rec {
  pname = "ezra-sil";
  version = "2.51";

  src = fetchzip {
    url = "https://software.sil.org/downloads/r/ezra/EzraSIL-${version}.zip";
    sha256 = "sha256-hGOHjvFVFLwyVkcoUz+7rQekCdn4oEOB+L16XRpthJM=";
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
