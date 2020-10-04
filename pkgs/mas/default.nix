{ pkgs
, lib
, stdenv
, writeScriptBin
}:

stdenv.mkDerivation rec {
  pname = "mas";
  version = "1.7.1";

  src = builtins.fetchurl {
    url = "https://github.com/mas-cli/mas/releases/download/v${version}/mas.pkg";
    sha256 = "03gjiiycvkr4kdl64cmz7gpfccv77q0mjj90sn2y87n6a3hrhkhs";
  };

  buildInputs = [ pkgs.libarchive ];

  unpackPhase = ''
    /usr/sbin/pkgutil --expand $src mas_unpacked
    bsdtar -xvf mas_unpacked/mas_components.pkg/Payload
  '';

  buildPhase = "true";

  installPhase = ''
    mkdir -p $out
    cp -r ./bin $out
    cp -r ./Frameworks $out
  '';

  postFixup = ''
    install_name_tool -change @rpath/MasKit.framework/Versions/A/MasKit $out/Frameworks/MasKit.framework/Versions/A/MasKit $out/bin/mas
    install_name_tool -change @rpath/Commandant.framework/Commandant  $out/Frameworks/MasKit.framework/Versions/A/Frameworks/Commandant.framework/Versions/A/Commandant $out/bin/mas
  '';

}
