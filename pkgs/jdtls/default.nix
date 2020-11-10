{ lib
, stdenv
, fetchurl
, makeWrapper
, openjdk11_headless
}:

# Run with: "${pkgs.jdt-language-server}/bin/jdt-language-server"
# Any additional args will be forwarded (e.g. "-Xms1G")
stdenv.mkDerivation rec {
  pname = "jdt-language-server";
  version = "0.62.0";
  timestamp = "202009291815";

  src = fetchurl {
    url = "https://download.eclipse.org/jdtls/milestones/${version}/jdt-language-server-${version}-${timestamp}.tar.gz";
    sha256 = "05p2frkzl0ikhbr3bjiqxm8gyxg1vn95ci591ig4sl9dbw0k4p8v";
  };

  sourceRoot = ".";

  buildInputs = [
    openjdk11_headless
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  installPhase = ''
    # Copy jars
    install -D -t $out/share/java/plugins/ plugins/*.jar

    # Copy config directories for linux and mac
    mkdir -p $out/share/config_{linux,mac}/
    install -D config_linux/* $out/share/config_linux/
    install -D config_mac/* $out/share/config_mac/

    # Get latest version of launcher jar
    # e.g. org.eclipse.equinox.launcher_1.5.800.v20200727-1323.jar
    launcher="$(ls $out/share/java/plugins/org.eclipse.equinox.launcher_* | sort -V | tail -n1)"

    # jdt-language-server needs to write to config location, so we create a temp
    # directory each time and copy the config_linux/ file there
    runtime_dir=/tmp/jdt-language-server

    makeWrapper ${openjdk11_headless}/bin/java $out/bin/jdt-language-server \
      --run "mkdir -p $runtime_dir" \
      --run "cp -r $out/share/config_* $runtime_dir" \
      --run "chmod -R 1777 $runtime_dir" \
      --add-flags "-Declipse.application=org.eclipse.jdt.ls.core.id1" \
      --add-flags "-Dosgi.bundles.defaultStartLevel=4" \
      --add-flags "-Declipse.product=org.eclipse.jdt.ls.core.product" \
      --add-flags "-Dlog.level=ALL" \
      --add-flags "-noverify" \
      --add-flags "-jar $launcher" \
      --add-flags "-configuration $runtime_dir/config_linux" \
      --add-flags "-data $runtime_dir/data" \
      --add-flags "--add-modules=ALL-SYSTEM" \
      --add-flags "--add-opens java.base/java.utilj=ALL-UNNAMED" \
      --add-flags "--add-opens java.base/java.lang=ALL-UNNAMED" \
      --prefix PATH : "$wrappedPath"
  '';

  meta = with lib; {
    homepage = "https://github.com/eclipse/eclipse.jdt.ls";
    description = "Java language server";
    license = licenses.epl20;
    maintainers = with maintainers; [ matt-snider ];
  };
}
