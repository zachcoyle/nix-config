{pkgs, ...}:
{
  image = ./wallpapers/platform.jpg;
  polarity = "dark";
  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  fonts = {
    serif = {
      package = pkgs.fira;
      name = "Fira Sans";
    };
    sansSerif = {
      package = pkgs.fira;
      name = "Fira Sans";
    };
    monospace = {
      package = pkgs.fira-code-nerdfont;
      name = "Fira Code Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      applications = 12;
      desktop = 10;
      popups = 14;
      terminal = 10;
    };
  };
  targets = {
    nixvim = {
      enable = false;
      transparent_bg = {
        main = true;
        sign_column = true;
      };
    };
  };
}
// (
  if pkgs.system == "x86_64-linux"
  then {
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
  else {}
)
