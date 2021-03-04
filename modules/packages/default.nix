{ lib
, pkgs
, ...
}:
with pkgs;
let

  commonPackages = [
    apg
    bat
    bc
    bvi
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
    gpeek
    imagemagickBig
    imgcat
    ipfs
    jump
    just
    lf
    loc
    lynx
    mariadb
    mdcat
    mpv
    nebula
    neofetch
    neovim
    niv
    nix-bundle
    nodejs-15_x
    nodePackages.eslint
    nodePackages.node2nix
    nodePackages.pyright
    nodePackages.typescript
    parallel
    pinentry
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
    terraform_0_14
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
    (pkgs.dwarf-fortress-packages.dwarf-fortress-full.override {
      enableDwarfTherapist = false;
      enableIntro = true;
      enableFPS = true;
    })
  ];

  linuxPackages = [
    #alacritty
    #android-studio
    #blender
    bviplus
    exfat
    #inkscape
    #kdenlive
    #steam
    #sublime
    #swift
    #vocal
  ];

  gpeek = writeScriptBin "gpeek" ''
    (
    cd /tmp
    git clone --depth 1 $@ || true
    reponame=$(basename $@)
    $EDITOR $reponame
    rm -rf $reponame
    )
  '';

in
{
  home.packages = commonPackages
    ++ lib.optionals (system == "x86_64-linux") linuxPackages
    ++ lib.optionals (system == "x86_64-darwin") darwinPackages;
}
