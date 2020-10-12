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

  darwin_enable_overlay = import ../.././overlays/darwin-enable.nix;
  newpackages_overlay = import ../.././overlays/newpackages.nix;
  customPackages_overlay = import ../.././overlays/customPackages.nix;

  commonPackages = [
    abduco
    apg
    autossh
    bat
    bc
    bundix
    bvi
    cachix
    ctags
    cups
    dvtm
    ed
    exercism
    fastlane
    fd
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
    nixops
    nodejs-14_x
    nodePackages_latest.eslint
    nodePackages_latest.node2nix
    nodePackages_latest.pyright
    nodePackages_latest.typescript
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
  nixpkgs.overlays = [
    customPackages_overlay
  ]
  ++ lib.optionals isDarwin [
    darwin_enable_overlay
  ];

  home.packages = commonPackages
    ++ lib.optionals isNixOS nixosPackages
    ++ lib.optionals isDarwin darwinPackages;
}
