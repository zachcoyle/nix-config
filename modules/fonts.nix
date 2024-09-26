{pkgs, ...}: {
  fonts =
    {
      packages = with pkgs; [
        departure-mono
        fira
        fira-code-nerdfont
        inter
        noto-fonts
        monaspace
        (google-fonts.override {
          fonts = [
            "David Libre"
            "Grenze Gotisch"
            "Oxanium"
            "Pixelify Sans"
            "Sixtyfour"
            "Tektur"
            "Tiny5"
            "Turret Road"
          ];
        })
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "FiraMono"
            "Gohu"
            "HeavyData"
            "Iosevka"
            "IosevkaTerm"
            "IosevkaTermSlab"
            "JetBrainsMono"
            "Lilex"
            "OpenDyslexic"
            "Monaspace"
          ];
        })
        (pkgs.callPackage ../packages/fonts/ezra-sil.nix {})
        (pkgs.callPackage ../packages/fonts/galatia-sil.nix {})
      ];
    }
    // (
      if pkgs.stdenv.isLinux
      then {
        fontDir.enable = true;
      }
      else {}
    );
}
