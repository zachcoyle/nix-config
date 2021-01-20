{ config, pkgs, lib, home, ... }: {
  home.stateVersion = "20.09";
  imports = [
    #./env.nix
    ./modules/dotfiles
    ./modules/packages
    ./modules/programs
    ./modules/vim
    ./modules/zsh
  ];
}
