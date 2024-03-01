{pkgs, ...}: {
  image = ./wallpapers/platform.jpg;
  polarity = "dark";
  base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  fonts = {
    serif = {
      package = pkgs.noto-fonts;
      name = "Noto Serif";
    };
    sansSerif = {
      package = pkgs.noto-fonts;
      name = "Noto Sans";
    };
    monospace = {
      package = pkgs.fira-code-nerdfont;
      name =
        if pkgs.stdenv.isDarwin
        then "FiraCode Nerd Font"
        else "Fira Code Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
    sizes = {
      applications = 12;
      desktop = 10;
      popups = 14;
      terminal =
        if pkgs.stdenv.isDarwin
        then 13
        else 10;
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
