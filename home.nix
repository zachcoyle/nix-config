{ config, pkgs, lib, ... }:
let
  darwin_enable_overlay = import ./overlays/darwin-enable.nix;
  newpackages_overlay = import ./overlays/newpackages.nix;
  vimPlugins_overlay = import ./overlays/vimPlugins.nix;
  neovim_nightly_overlay = import (builtins.fetchTarball {
    url = https://github.com/mjlbach/neovim-nightly-overlay/archive/master.tar.gz;
  });
  customPackages_overlay = import ./overlays/customPackages.nix;

  machine = import ./machine.nix;
  isDarwin = machine.operatingSystem == "Darwin";
  isNixOS = machine.operatingSystem == "NixOS";

  prettierPkgs = pkgs.yarn2nix-moretea.mkYarnPackage {
    name = "prettierPkgs";
    src = ./pkgs/node_packages/prettierPkgs;
    packageJSON = ./pkgs/node_packages/prettierPkgs/package.json;
    yarnLock = ./pkgs/node_packages/prettierPkgs/yarn.lock;
    publishBinsFor = [ "prettier" ];
  };

in
{
  imports = [ ./env.nix ] ++ lib.optionals isNixOS [ ./programs-nixos.nix ];

  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    vimPlugins_overlay
    neovim_nightly_overlay
    customPackages_overlay
  ]
  ++ lib.optionals isDarwin [
    darwin_enable_overlay
  ];

  home.file.".config/alacritty/alacritty.yml".text =
    builtins.readFile ./dotfiles/alacritty.yml;


  home.file."Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".text =
    builtins.readFile ./dotfiles/iterm2/Profiles.json;

  home.file."Library/Application Support/VSCodium/User/settings.json".text = ''
    {
      "update": {
        "mode": "none"
      },
      "vscode-neovim.neovimPath": "${config.programs.neovim.finalPackage}/bin/nvim",
      "editor.formatOnSave": true,
      "editor.lineNumbers": "relative"
      "editor.cursorStyle": "block",
      "editor.fontLigatures": true,
      "editor.fontFamily": "FiraCode Nerd Font",
    }
  '';

  home.packages = with pkgs; [
    abduco
    apg
    autossh
    nodePackages_latest.bash-language-server
    bat
    bc
    bundix
    bvi
    cachix
    clojure-lsp
    ctags
    cups
    nodePackages_latest.dockerfile-language-server-nodejs
    dvtm
    ed
    nodePackages_latest.eslint
    exercism
    fastlane
    fd
    gofumpt
    haskellPackages.haskell-language-server
    imagemagickBig
    imgcat
    ipfs
    nodePackages_latest.javascript-typescript-langserver
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
    nixops
    nix-bundle
    nixpkgs-fmt
    nodePackages_latest.node2nix
    nodejs-14_x
    ormolu
    parallel
    powerline-rs
    prettierPkgs
    nodePackages_latest.pyright
    python38Full
    python3Packages.black
    python3Packages.isort
    python3Packages.poetry
    ranger
    redis
    ripgrep
    rls
    rnix-lsp
    rubocop
    ruby
    rustfmt
    safe-rm
    shfmt
    solargraph
    speedtest-cli
    stack
    stow
    teamocil
    tig
    tldr
    tmate
    tree
    nodePackages_latest.typescript
    nodePackages_latest.typescript-language-server
    uncrustify
    units
    unixODBC
    nodePackages_latest.vim-language-server
    watchman
    wget
    yarn
    youtube-dl
    zsh-completions #TODO
  ] ++ lib.optionals isNixOS [
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
  ] ++ lib.optionals isDarwin [
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

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    autocd = true;
    shellAliases = {
      cat = "bat --theme TwoDark --paging never";
      ls = "lsd -F";
      rm = "safe-rm -iv";
      yeet =
        "home-manager expire-generations `date --iso-8601`; nix-env -p /nix/var/nix/profiles/system --delete-generations old; nix-collect-garbage -d; nix-store --optimise";
      packageScripts = "jq .scripts package.json";
    };
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "vim";
      FASTLANE_OPT_OUT_USAGE = "YES";
      NIX_IGNORE_SYMLINK_STORE = "1";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
      REACT_TERMINAL = "iTerm";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "adb"
        "bundler"
        "cabal"
        "cargo"
        "catimg"
        "celery"
        "colored-man-pages"
        "docker"
        "docker-compose"
        "docker-machine"
        "fzf"
        "git"
        "git-flow"
        "gnu-utils"
        "gradle"
        "iterm2"
        "lein"
        "npm"
        "redis-cli"
        "rust"
        "rustup"
        "sudo"
        "terraform"
        "tig"
        "vi-mode"
        "xcode"
        "yarn"
      ];
      extraConfig = ''
        source ${pkgs.jump}/share/zsh/site-functions/_jump
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        ${builtins.readFile ./dotfiles/p10k.zsh}
      '';
    };
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    stdlib = builtins.readFile ./dotfiles/direnvrc;
  };

  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.htop = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Zach Coyle";
    userEmail = "zach.coyle@gmail.com";
    package = pkgs.gitAndTools.gitFull;
    delta = { enable = true; };
    extraConfig = {
      pull = {
        ff = "only";
      };
      fetch = {
        prune = "true";
      };
      commit = {
        gpgsign = "true";
      };
    };
  };

  programs.jq = {
    enable = true;
  };

  programs.gpg = {
    enable = true;
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = false; # disabled for iterm
    keyMode = "vi";
    newSession = true;
    tmuxp.enable = true;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      resurrect
      gruvbox
    ];
    extraConfig = builtins.readFile ./dotfiles/tmux.conf;
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ./dotfiles/neovim/init.vim;

    plugins = with pkgs.vimPlugins; with builtins; [
      { plugin = auto-pairs; }
      { plugin = colorizer; }
      { plugin = command-t; config = readFile ./dotfiles/neovim/command-t-config.vim; }
      { plugin = conjure; }
      { plugin = deol-nvim; }
      { plugin = deoplete-nvim; config = readFile ./dotfiles/neovim/deoplete-nvim-config.vim; }
      { plugin = direnv-vim; config = readFile ./dotfiles/neovim/direnv-vim-config.vim; }
      { plugin = editorconfig-vim; }
      { plugin = emmet-vim; }
      { plugin = fugitive; }
      { plugin = gruvbox; config = readFile ./dotfiles/neovim/gruvbox-config.vim; }
      { plugin = LanguageClient-neovim; config = readFile ./dotfiles/neovim/LanguageClient-neovim-config.vim; }
      { plugin = lf-vim; }
      { plugin = neoformat; config = readFile ./dotfiles/neovim/neoformat-config.vim; }
      { plugin = nerdtree-git-plugin; }
      { plugin = rainbow; config = readFile ./dotfiles/neovim/rainbow-config.vim; }
      { plugin = scrollbar-nvim; config = readFile ./dotfiles/neovim/scrollbar-nvim-config.vim; }
      { plugin = surround; }
      { plugin = tabular; }
      { plugin = The_NERD_tree; config = readFile ./dotfiles/neovim/The_NERD_tree-config.vim; }
      { plugin = undotree; }
      { plugin = vim-airline-themes; config = readFile ./dotfiles/neovim/vim-airline-themes-config.vim; }
      { plugin = vim-airline; config = readFile ./dotfiles/neovim/vim-airline-config.vim; }
      { plugin = vim-closetag; config = readFile ./dotfiles/neovim/vim-closetag-config.vim; }
      { plugin = vim-commentary; }
      { plugin = vim-cursorword; }
      { plugin = vim-devicons; }
      { plugin = vim-dispatch; }
      { plugin = vim-fireplace; }
      { plugin = vim-gitbranch; }
      { plugin = vim-hardtime; config = readFile ./dotfiles/neovim/vim-hardtime-config.vim; }
      { plugin = vim-multiple-cursors; }
      { plugin = vim-nerdtree-syntax-highlight; }
      { plugin = vim-nerdtree-tabs; }
      { plugin = vim-polyglot; }
      { plugin = vim-repeat; }
      { plugin = vim-ripgrep; config = readFile ./dotfiles/neovim/vim-ripgrep-config.vim; }
      { plugin = vim-sensible; }
      { plugin = vim-signify; config = readFile ./dotfiles/neovim/vim-signify-config.vim; }
      { plugin = vim-startify; config = readFile ./dotfiles/neovim/vim-startify-config.vim; }
      { plugin = vim-visual-multi; }
      { plugin = vim-which-key; }
      { plugin = vimspector; }
    ];
  };
}
