{pkgs, ...}: {
  image = ./wallpapers/platform.jpg;
  polarity = "dark";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  base16Scheme = "${pkgs.base16-schemes}/share/themes/atelier-estuary.yaml";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/marrakesh.yaml";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/paraiso.yaml";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/greenscreen.yaml";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/tarot.yaml";
  # base16Scheme = "${pkgs.base16-schemes}/share/themes/woodland.yaml";
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
