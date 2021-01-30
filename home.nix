{ ... }: {
  home.stateVersion = "20.09";
  imports = [
    ./modules/dotfiles
    ./modules/packages
    ./modules/programs
    ./modules/vim
    ./modules/zsh
  ];
}
