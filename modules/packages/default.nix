{ lib
, pkgs
, home
, ...
}:
with pkgs;
let
  machine = import ../../machine.nix;
  isDarwin = machine.operatingSystem == "Darwin";
  isNixOS = machine.operatingSystem == "NixOS";

  customPackages_overlay = import ../.././overlays/customPackages.nix;

  commonPackages = [
    abduco
    apg
    autossh
    bat
    bc
    bundix
    bvi
    byobu
    cachix
    ctags
    cups
    dvtm
    ed
    exercism
    fastlane
    fd
    gitAndTools.gh
    gitAndTools.git-ignore
    gitAndTools.git-imerge
    gitAndTools.git-interactive-rebase-tool
    gitAndTools.git-machete
    gitAndTools.hub
    gitAndTools.lab
    gitAndTools.lefthook
    imagemagickBig
    imgcat
    ipfs
    jump
    just
    lf
    loc
    lsd
    lynx
    mariadb
    mdcat
    mpv
    nebula
    neofetch
    niv
    nix-bundle
    #nixops
    nodejs-15_x
    nodePackages.eslint
    nodePackages.node2nix
    nodePackages.pyright
    nodePackages.typescript
    parallel
    powerline-rs
    python38Full
    python3Packages.poetry
    ranger
    redis
    ripgrep
    ruby
    safe-rm
    shfmt
    speedtest-cli
    stack
    stow
    teamocil
    terraform
    tig
    tldr
    tmate
    tree
    units
    watchman
    wget
    yarn
    youtube-dl
    zsh-completions #TODO
  ];

  darwinPackages = [
    cocoapods
    coreutils
    curl
    diffutils
    docker
    findutils
    killall
    less
    man
    more
    nix-zsh-completions
    openssl
    patch
    watch
  ];

  nixosPackages = [
    alacritty
    android-studio
    blender
    dwarf-fortress-packages.dwarf-fortress-full
    exfat
    inkscape
    kdenlive
    steam
    sublime
    swift
    vocal
  ];


in
{
  nixpkgs.overlays = [ customPackages_overlay ];

  home.packages = commonPackages
    ++ lib.optionals isNixOS nixosPackages
    ++ lib.optionals isDarwin darwinPackages;
}
