{ config, pkgs, lib, ... }:
{
  imports = [
    ./env.nix
    ./modules/dotfiles
    ./modules/packages
    ./modules/programs
    ./modules/vim
    ./modules/zsh
  ];
}
