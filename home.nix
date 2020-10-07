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


  nodePkgs = with pkgs.nodePackages_latest; [
    bash-language-server
    dockerfile-language-server-nodejs
    eslint
    javascript-typescript-langserver
    pyright
    node2nix
    typescript
    typescript-language-server
    vim-language-server
  ];


  languageServers = with pkgs; [
    clojure-lsp
    haskellPackages.haskell-language-server
    rnix-lsp
    rls
    solargraph
  ];

  formatters = with pkgs; [
    gofumpt
    nixpkgs-fmt
    ormolu
    python3Packages.black
    python3Packages.isort
    prettierPkgs
    rubocop
    rustfmt
    shfmt
    uncrustify
  ];

  languages = with pkgs; [
    nodejs-14_x
    python38Full
    ruby
  ] ++ lib.optionals isNixOS [ swift ];

  buildTools = with pkgs; [
    fastlane
    just
    python3Packages.poetry
    stack
  ];

  expressionGenerators = with pkgs; [
    bundix
  ];

  packageManagers = with pkgs; [
    yarn
    niv
  ] ++ lib.optionals isDarwin [ cocoapods ];

  shellTools = with pkgs; [
    powerline-rs
    safe-rm
    jump
    ranger
    bat
    stow
    tldr
    parallel
    ripgrep
    tmate
    tree
    zsh-completions #TODO
  ];

  editors = with pkgs; [
    bvi
  ];

  networkingTools = with pkgs; [
    speedtest-cli
    ipfs
    nebula
    autossh
    wget
  ];

  dbClients = with pkgs; [
    redis
    mariadb
  ];

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
    bc
    cachix
    ctags
    cups
    dvtm
    ed
    exercism
    fd
    imagemagickBig
    imgcat
    loc
    lsd
    lynx
    mdcat
    mpv
    nixops
    teamocil
    tig
    units
    unixODBC
    watchman
    youtube-dl
  ] ++ lib.flatten [
    buildTools
    dbClients
    editors
    expressionGenerators
    formatters
    languages
    languageServers
    networkingTools
    nodePkgs
    packageManagers
    shellTools
  ] ++ lib.optionals isNixOS [
    android-studio
    alacritty
    blender
    dwarf-fortress-packages.dwarf-fortress-full
    exfat
    inkscape
    kdenlive
    steam
    sublime
    vocal
  ] ++ lib.optionals isDarwin [
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
      { plugin = conjure; }
      { plugin = ctrlp-vim; config = readFile ./dotfiles/neovim/ctrlp-vim-config.vim; }
      { plugin = deol-nvim; }
      { plugin = deoplete-nvim; config = readFile ./dotfiles/neovim/deoplete-nvim-config.vim; }
      { plugin = direnv-vim; config = readFile ./dotfiles/neovim/direnv-vim-config.vim; }
      { plugin = editorconfig-vim; }
      { plugin = fugitive; }
      { plugin = gruvbox; config = readFile ./dotfiles/neovim/gruvbox-config.vim; }
      { plugin = LanguageClient-neovim; config = readFile ./dotfiles/neovim/LanguageClient-neovim-config.vim; }
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
      { plugin = vim-better-whitespace; config = readFile ./dotfiles/neovim/vim-better-whitespace-config.vim; }
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
      { plugin = vim-sensible; }
      { plugin = vim-signify; config = readFile ./dotfiles/neovim/vim-signify-config.vim; }
      { plugin = vim-startify; config = readFile ./dotfiles/neovim/vim-startify-config.vim; }
      { plugin = vim-which-key; }
      { plugin = vimspector; }
    ];
  };
}
