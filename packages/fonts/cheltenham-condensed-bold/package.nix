{stdenvNoCC, ...}:
stdenvNoCC.mkDerivation {
  pname = "cheltenham-condensed-bold";
  version = "unstable";

  src = ./src;

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
