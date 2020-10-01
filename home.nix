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
    python38Packages.poetry
    stack
  ];

  expressionGenerators = with pkgs; [
    bundix
  ];

  packageManagers = with pkgs; [
    python38Packages.pip
    python38Packages.virtualenv
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
  imports = [ ./env.nix ] ++ lib.optionals isNixOS [ ./home-nixos ];

  programs.home-manager.enable = true;

  nixpkgs.overlays = [
    vimPlugins_overlay
    neovim_nightly_overlay
    customPackages_overlay
  ]
  ++ lib.optionals isDarwin [
    darwin_enable_overlay
  ];

  home.file."Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".text =
    builtins.readFile ./dotfiles/Profiles.json;

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
      "editor.fontFamily": "FiraCode Nerd Font
    }
  '';

  home.packages = with pkgs; [
    abduco
    apg
    bc
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
      mas = "/usr/local/bin/mas";
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
    extraConfig = ''
      set -g mouse on
      set-option -g status-position top
    '';
  };

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    package = pkgs.neovim-nightly;

    extraConfig = builtins.readFile ./dotfiles/init.vim;

    plugins = with pkgs.vimPlugins; [
      auto-pairs
      colorizer
      conjure
      {
        plugin = ctrlp-vim;
        config = "let g:ctrlp_custom_ignore = 'node_modules\|DS_Store\|git'";
      }
      deol-nvim
      {
        plugin = deoplete-nvim;
        config = ''
          let g:deoplete#enable_at_startup = 1
          let g:deoplete#ignore_case = 1
          let g:deoplete#ignorecase = 1
          inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
        '';
      }
      {
        plugin = direnv-vim;
        config = ''
          if exists("$EXTRA_VIM")
            for path in split($EXTRA_VIM, ':')
              exec "source ".path
            endfor
          endif
        '';
      }
      editorconfig-vim
      fugitive
      {
        plugin = gruvbox;
        config = "autocmd vimenter * colorscheme gruvbox";
      }
      {
        plugin = LanguageClient-neovim;
        config = ''
          let g:LanguageClient_serverCommands = {
                \ 'c'               : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
                \ 'clojure'         : ['clojure-lsp'],
                \ 'cpp'             : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
                \ 'dockerfile'      : ['docker-langserver', '--stdio'],
                \ 'go'              : ['gopls'],
                \ 'haskell'         : ['haskell-language-server', '--lsp'],
                \ 'javascript'      : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
                \ 'javascriptreact' : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
                \ 'json'            : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
                \ 'nix'             : ['rnix-lsp'],
                \ 'objc'            : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
                \ 'python'          : ['poetry', 'run', 'pyls'],
                \ 'ruby'            : ['solargraph', 'stdio'],
                \ 'rust'            : ['rls'],
                \ 'sh'              : ['bash-language-server', 'start'],
                \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
                \ 'typescript'      : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
                \ 'typescriptreact' : ['typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
                \ 'vim'             : ['vim-language-server', '--stdio'],
                \ }

          nmap <silent>K <Plug>(lcn-hover)
          nmap <silent> gd <Plug>(lcn-definition)
          nmap <silent> <F2> <Plug>(lcn-rename)
          let g:LanguageClient_autoStart = 1
        '';
      }
      {
        plugin = neoformat;
        config = ''
          augroup fmt
            autocmd!
            autocmd BufWritePre * undojoin | Neoformat
          augroup END

          let g:neoformat_enabled_c = ['clangformat']
          let g:neoformat_enabled_cpp = ['uncrustify']
          let g:neoformat_enabled_go = ['gofumports', 'gofumpt']
          let g:neoformat_enabled_graphql = ['prettier']
          let g:neoformat_enabled_haskell = ['ormolu']
          let g:neoformat_enabled_javascript = ['prettier', 'eslint_d']
          let g:neoformat_enabled_javascriptreact = ['prettier', 'eslint_d']
          let g:neoformat_enabled_json = ['prettier']
          let g:neoformat_enabled_nix = ['nixpkgsfmt']
          let g:neoformat_enabled_objc = ['uncrustify']
          let g:neoformat_enabled_python = ['isort' , 'black']
          let g:neoformat_enabled_ruby = ['rubocop']
          let g:neoformat_enabled_rust = ['rustfmt']
          let g:neoformat_enabled_typescript = ['prettier']
          let g:neoformat_enabled_typescriptreact = ['prettier']
          let g:neoformat_run_all_formatters = 1
        '';
      }
      nerdtree-git-plugin
      {
        plugin = rainbow;
        config = "let g:rainbow_active = 1";
      }
      {
        plugin = scrollbar-nvim;
        config = ''
          augroup your_config_scrollbar_nvim
              autocmd!
              autocmd BufEnter    * silent! lua require('scrollbar').show()
              autocmd BufLeave    * silent! lua require('scrollbar').clear()

              autocmd CursorMoved * silent! lua require('scrollbar').show()
              autocmd VimResized  * silent! lua require('scrollbar').show()

              autocmd FocusGained * silent! lua require('scrollbar').show()
              autocmd FocusLost   * silent! lua require('scrollbar').clear()
          augroup end
        '';
      }
      {
        plugin = vim-startify;
        config = ''
          let g:startify_session_dir ='~/.config/nvim/session'
          let g:startify_fortune_use_unicode = 1
          let g:startify_lists = [
                    \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
                    \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
                    \ { 'type': 'sessions',  'header': ['   Sessions']       },
                    \ { 'type': 'files',     'header': ['   Files']            },
                    \ ]
          let g:startify_bookmarks = [
                   \ {'n': '~/.config/nixpkgs'},
                   \ ]
        '';
      }
      surround
      tabular
      {
        plugin = The_NERD_tree;
        config = ''
          if exists('g:vscode') " hide if inside vscode
          else
          autocmd vimenter * NERDTree
          autocmd VimEnter * wincmd p
          let NERDTreeMinimalUI = 1
          let NERDTreeDirArrows = 1
          let NERDTreeShowHidden=1
          autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
          function! OnlyAndNerdtree()
            let currentWindowID = win_getid()
            windo if win_getid() != currentWindowID && &filetype != 'nerdtree' | close | endif
          endfunction

          function! IsNERDTreeOpen()
            return exists("t:NERDTreeBufName") && (bufwinnr(t:NERDTreeBufName != -1))
          endfunction

          function! SyncTree()
            if &modifiable && IsNERDTreeOpen() && strlen(expand('%')) > 0 && !&diff
              NERDTreeFind
              wincmd p
            endif
          endfunction

          autocmd BufEnter * call SyncTree()

          command! Only call OnlyAndNerdtree()

          endif
        '';
      }
      undotree
      {
        plugin = vim-airline;
        config = ''
          let g:airline_powerline_fonts = 1
          let g:airline#extensions#tabline#enabled = 1
          let g:airline#extensions#tabline#buffers_label = ' buffers'
          let g:airline#extensions#tabline#fnamemod = ':t'
        '';
      }
      {
        plugin = vim-airline-themes;
        config = ''
          "let g:airline_theme = 'angr'
          "let g:airline_theme = 'gruvbox'
        '';
      }
      {
        plugin = vim-better-whitespace;
        config = ''
          let g:better_whitespace_enabled=1
          let g:strip_whitespace_on_save=1
        '';
      }
      {
        plugin = vim-closetag;
        config = ''
          let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.jsx,*.tsx'
          let g:closetag_regions = {
              \ 'javascript.jsx': 'jsxRegion',
              \ 'typescript.tsx': 'jsxRegion,tsxRegion',
              \ }
        '';
      }
      vim-commentary
      vim-cursorword
      vim-devicons
      vim-dispatch
      vim-fireplace
      vim-gitbranch
      {
        plugin = vim-hardtime;
        config = "let g:hardtime_default_on = 0";
      }
      vim-multiple-cursors
      vim-nerdtree-syntax-highlight
      vim-nerdtree-tabs
      vim-polyglot
      vim-repeat
      vim-sensible
      {
        plugin = vim-signify;
        config = ''
          let g:signify_sign_add = ''
          let g:signify_sign_change = ''
          let g:signify_sign_delete = ''
          let g:signify_sign_show_count = 0
        '';
      }
      vim-which-key
      vimspector
    ];
  };
}
