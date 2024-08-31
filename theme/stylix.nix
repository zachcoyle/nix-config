{ pkgs, ... }:
{
  stylix = {
    enable = true;
    image = ./wallpapers/platform.png;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
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
        name = "Monaspace Krypton";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 14;
        terminal = if pkgs.stdenv.isDarwin then 13 else 10;
      };
    };
    targets = {
      nixvim.enable = false;
    };
  };
}
