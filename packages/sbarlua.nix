{
  pkgs,
  src,
  ...
}:
pkgs.darwin.apple_sdk_11_0.stdenv.mkDerivation {
  pname = "sbarlua";
  version = "unstable";
  inherit src;
  nativeBuildInputs = with pkgs;
  with pkgs.darwin.apple_sdk_11_0.frameworks; [
    gcc
    gnumake
  ];
  buildInputs = with pkgs;
  with pkgs.darwin.apple_sdk_11_0.frameworks; [
    readline
    CoreFoundation
  ];
  installPhase = ''
    mv bin $out
  '';
}
