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
        nerd-fonts.fira-code
        nerd-fonts.fira-mono
        nerd-fonts.gohufont
        nerd-fonts.heavy-data
        nerd-fonts.iosevka
        nerd-fonts.iosevka-term
        nerd-fonts.jetbrains-mono
        nerd-fonts.symbols-only
        nerd-fonts.lilex
        nerd-fonts.open-dyslexic
        nerd-fonts.monaspace
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
