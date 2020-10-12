{ pkgs
, home
, programs
, ...
}:

with pkgs;
let
  neovim_nightly_overlay = import (builtins.fetchTarball {
    url = https://github.com/mjlbach/neovim-nightly-overlay/archive/master.tar.gz;
  });

  vimPlugins_overlay =
    self: super:
    let
      inherit (super.vimUtils) buildVimPluginFrom2Nix;
    in
    {
      vimPlugins = super.vimPlugins // {
        nerdtree-git-plugin = buildVimPluginFrom2Nix {
          pname = "nerdtree-git-plugin";
          version = "2020-09-25";
          src = super.fetchFromGitHub {
            owner = "Xuyuanp";
            repo = "nerdtree-git-plugin";
            rev = "85c4bed898d2d755a2a2ffbfc2433084ce107cdd";
            sha256 = "RJk9eYlW5Avyv7lkmYS/skB2B17b/uVEQOWgCUYvGtU=";
          };
          meta.homepage = "https://github.com/Xuyuanp/nerdtree-git-plugin/";
        };

        scrollbar-nvim = buildVimPluginFrom2Nix {
          pname = "scrollbar-nvim";
          version = "2020-09-28";
          src = super.fetchFromGitHub {
            owner = "Xuyuanp";
            repo = "scrollbar.nvim";
            rev = "72a4174a47a89b7f89401fc66de0df95580fa48c";
            sha256 = "Pmn1RHCYf3Ty0mL+5PshIXsF5heLb2TB2YT9VS85c4I=";
          };
          meta.homepage = "https://github.com/Xuyuanp/scrollbar.nvim/";
        };

        vim-ripgrep = buildVimPluginFrom2Nix {
          pname = "vim-ripgrep";
          version = "2018-09-08";
          src = super.fetchFromGitHub {
            owner = "jremmen";
            repo = "vim-ripgrep";
            rev = "ec87af6b69387abb3c4449ce8c4040d2d00d745e";
            sha256 = "sFp57KGnMu3a7pTNPx3vNfuPhMhJqc22tHWBTF02xa8=";
          };
        };

        discord-nvim = buildVimPluginFrom2Nix {
          pname = "discord-nvim";
          version = "2019-12-29";
          src = super.fetchFromGitHub {
            owner = "aurieh";
            repo = "discord.nvim";
            rev = "a9c4587359e0660051dbd099f93d161bca2b1e9a";
            sha256 = "XrxTskVHo12NM9boLd5ungoHkqfwvuLK/BXWfDhup/s=";
          };
        };
      };
    };

  prettierPkgs = pkgs.yarn2nix-moretea.mkYarnPackage {
    name = "prettierPkgs";
    src = ../.././pkgs/node_packages/prettierPkgs;
    packageJSON = ../.././pkgs/node_packages/prettierPkgs/package.json;
    yarnLock = ../.././pkgs/node_packages/prettierPkgs/yarn.lock;
    publishBinsFor = [ "prettier" ];
  };

  formatters = [
    gofumpt
    nixpkgs-fmt
    ormolu
    prettierPkgs
    python3Packages.black
    python3Packages.isort
    rubocop
    rustfmt
    uncrustify
  ];

  #TODO: update pyls when it's fixed

  lspConfig = ''
    let g:LanguageClient_serverCommands = {
          \ 'c'               : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'clojure'         : ['${clojure-lsp}/bin/clojure-lsp'],
          \ 'cpp'             : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'dockerfile'      : ['${nodePackages_latest.dockerfile-language-server-nodejs}/bin/docker-langserver', '--stdio'],
          \ 'go'              : ['${gopls}/bin/gopls'],
          \ 'haskell'         : ['${haskellPackages.haskell-language-server}/bin/haskell-language-server', '--lsp'],
          \ 'javascript'      : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'javascriptreact' : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'json'            : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'nix'             : ['${rnix-lsp}/bin/rnix-lsp'],
          \ 'objc'            : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'python'          : ['${poetry}/bin/poetry', 'run', 'pyls'],
          \ 'ruby'            : ['${solargraph}/bin/solargraph', 'stdio'],
          \ 'rust'            : ['${rls}/bin/rls'],
          \ 'sh'              : ['${nodePackages_latest.bash-language-server}/bin/bash-language-server', 'start'],
          \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'typescript'      : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'typescriptreact' : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'vim'             : ['${nodePackages_latest.vim-language-server}/bin/vim-language-server', '--stdio'],
          \ }
  '';

in
{

  nixpkgs.overlays = [
    neovim_nightly_overlay
    vimPlugins_overlay
  ];

  home.packages = formatters;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ./config/init.vim;

    plugins = with pkgs.vimPlugins; with builtins; [
      { plugin = auto-pairs; }
      { plugin = colorizer; }
      { plugin = command-t; config = readFile ./config/command-t-config.vim; }
      { plugin = conjure; }
      { plugin = deol-nvim; }
      { plugin = deoplete-nvim; config = readFile ./config/deoplete-nvim-config.vim; }
      { plugin = direnv-vim; config = readFile ./config/direnv-vim-config.vim; }
      { plugin = editorconfig-vim; }
      { plugin = emmet-vim; config = readFile ./config/emmet-vim-config.vim; }
      { plugin = fugitive; }
      { plugin = gruvbox; config = readFile ./config/gruvbox-config.vim; }
      { plugin = LanguageClient-neovim; config = (readFile ./config/LanguageClient-neovim-config.vim) + lspConfig; }
      { plugin = lf-vim; }
      { plugin = neoformat; config = readFile ./config/neoformat-config.vim; }
      { plugin = nerdtree-git-plugin; }
      { plugin = rainbow; config = readFile ./config/rainbow-config.vim; }
      { plugin = scrollbar-nvim; config = readFile ./config/scrollbar-nvim-config.vim; }
      { plugin = surround; }
      { plugin = tabular; }
      { plugin = The_NERD_tree; config = readFile ./config/The_NERD_tree-config.vim; }
      { plugin = undotree; }
      { plugin = vim-airline-themes; config = readFile ./config/vim-airline-themes-config.vim; }
      { plugin = vim-airline; config = readFile ./config/vim-airline-config.vim; }
      { plugin = vim-closetag; config = readFile ./config/vim-closetag-config.vim; }
      { plugin = vim-commentary; }
      { plugin = vim-cursorword; }
      { plugin = vim-devicons; }
      { plugin = vim-dispatch; }
      { plugin = vim-easymotion; }
      { plugin = vim-fireplace; }
      { plugin = vim-gitbranch; }
      { plugin = vim-hardtime; config = readFile ./config/vim-hardtime-config.vim; }
      { plugin = vim-multiple-cursors; }
      { plugin = vim-nerdtree-syntax-highlight; }
      { plugin = vim-nerdtree-tabs; }
      { plugin = vim-polyglot; }
      { plugin = vim-repeat; }
      { plugin = vim-ripgrep; config = readFile ./config/vim-ripgrep-config.vim; }
      { plugin = vim-sensible; }
      { plugin = vim-signify; config = readFile ./config/vim-signify-config.vim; }
      { plugin = vim-startify; config = readFile ./config/vim-startify-config.vim; }
      { plugin = vim-visual-multi; }
      { plugin = vim-which-key; }
      { plugin = vimspector; }
    ];
  };
}
