{pkgs, ...}: {
  cursor = {
    name = "Bibata-Modern-Gruvbox";
    size = 24;
    package = pkgs.stdenvNoCC.mkDerivation {
      # TODO: package this properly
      pname = "bibata-cursors-gruvbox";
      version = "unstable";
      src = ./Bibata-Modern-Gruvbox.tar.xz;
      installPhase = ''
        mkdir -p $out/share/icons
        cp -r . $out/share/icons/Bibata-Modern-Gruvbox
      '';
    };
  };
  opacity = {
    popups = 0.8;
    terminal = 0.8;
  };
}
