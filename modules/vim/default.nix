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

        nvim-tree-lua = buildVimPluginFrom2Nix {
          pname = "nvim-tree-lua";
          version = "2020-10-26";
          src = super.fetchFromGitHub {
            owner = "kyazdani42";
            repo = "nvim-tree.lua";
            rev = "ebf6f2a21ab55f4a157fffa8a1b3ae9c414c1022";
            sha256 = "Mp3pIhJ3lAZ7qks7JVmqNdiMkisufuRCNUjrAQufEB0=";
          };
        };

        nvim-web-devicons = buildVimPluginFrom2Nix {
          pname = "nvim-web-devicons";
          version = "2020-10-28";
          src = super.fetchFromGitHub {
            owner = "kyazdani42";
            repo = "nvim-web-devicons";
            rev = "23a9fbb6de546a4cb2e7d2fe2ff4e09e99b5fd2e";
            sha256 = "42GQ/6Gpopu+SjBa8QA1xGbwK8E3At1Oq6mk8sGXU9o=";
          };
        };

        vim-dadbod-ui = buildVimPluginFrom2Nix {
          pname = "vim-dadbod-ui";
          version = "2020-10-12";
          src = super.fetchFromGitHub {
            owner = "kristijanhusak";
            repo = "vim-dadbod-ui";
            rev = "ed73c98c9c5f631f390b651e46e22c04d44420b3";
            sha256 = "3rIlTIJ85FSGzjxyq1LWqpuywzdbnOkN2y81DVCQbcs=";
          };
        };

      };
    };

  prettierPkgs = yarn2nix-moretea.mkYarnPackage {
    name = "prettierPkgs";
    src = ../../pkgs/node_packages/prettierPkgs;
    packageJSON = ../../pkgs/node_packages/prettierPkgs/package.json;
    yarnLock = ../../pkgs/node_packages/prettierPkgs/yarn.lock;
    publishBinsFor = [ "prettier" ];
  };

  pyls = python3Packages.python-language-server.overrideAttrs (oldAttrs: {
    doInstallCheck = false;
  });

  formatters = [
    gofumpt
    ktlint
    nixpkgs-fmt
    ormolu
    #nodePackages.prettier
    prettierPkgs
    python3Packages.black
    python3Packages.isort
    rubocop
    rustfmt
    terraform
    uncrustify
  ];

  lspConfig = ''
    let g:LanguageClient_serverCommands = {
          \ 'c'               : ['${ccls}/bin/ccls'],
          \ 'clojure'         : ['${clojure-lsp}/bin/clojure-lsp'],
          \ 'cpp'             : ['${ccls}/bin/ccls'],
          \ 'dockerfile'      : ['${nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver', '--stdio'],
          \ 'go'              : ['${gopls}/bin/gopls'],
          \ 'haskell'         : ['${haskellPackages.haskell-language-server}/bin/haskell-language-server', '--lsp'],
          \ 'javascript'      : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'javascriptreact' : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'json'            : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'kotlin'          : ['${nur.repos.zachcoyle.kotlin-language-server}/bin/kotlin-language-server'],
          \ 'lua'             : ['${lua53Packages.lua-lsp}/bin/lua-lsp'],
          \ 'nix'             : ['${rnix-lsp}/bin/rnix-lsp'],
          \ 'objc'            : ['${ccls}/bin/ccls'],
          \ 'python'          : ['${pyls}/bin/pyls'],
          \ 'ruby'            : ['${solargraph}/bin/solargraph', 'stdio'],
          \ 'rust'            : ['${rls}/bin/rls'],
          \ 'sh'              : ['${nodePackages.bash-language-server}/bin/bash-language-server', 'start'],
          \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'typescript'      : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'typescriptreact' : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'vim'             : ['${nodePackages.vim-language-server}/bin/vim-language-server', '--stdio'],
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
      { plugin = conjure; }
      { plugin = deol-nvim; }
      { plugin = deoplete-nvim; config = readFile ./config/deoplete-nvim-config.vim; }
      { plugin = direnv-vim; config = readFile ./config/direnv-vim-config.vim; }
      { plugin = editorconfig-vim; }
      { plugin = emmet-vim; config = readFile ./config/emmet-vim-config.vim; }
      { plugin = fugitive; }
      { plugin = fzf-vim; config = readFile ./config/fzf-vim-config.vim; }
      { plugin = gruvbox; config = readFile ./config/gruvbox-config.vim; }
      { plugin = LanguageClient-neovim; config = (readFile ./config/LanguageClient-neovim-config.vim) + lspConfig; }
      { plugin = lf-vim; }
      { plugin = neoformat; config = readFile ./config/neoformat-config.vim; }
      { plugin = nvim-tree-lua; config = readFile ./config/nvim-tree-lua-config.vim; }
      { plugin = nvim-treesitter; }
      { plugin = nvim-web-devicons; }
      { plugin = rainbow; config = readFile ./config/rainbow-config.vim; }
      { plugin = scrollbar-nvim; config = readFile ./config/scrollbar-nvim-config.vim; }
      { plugin = surround; }
      { plugin = tabular; }
      { plugin = undotree; }
      { plugin = vim-airline-themes; config = readFile ./config/vim-airline-themes-config.vim; }
      { plugin = vim-airline; config = readFile ./config/vim-airline-config.vim; }
      { plugin = vim-closetag; config = readFile ./config/vim-closetag-config.vim; }
      { plugin = vim-commentary; }
      { plugin = vim-cursorword; }
      { plugin = vim-dadbod-ui; }
      { plugin = vim-dadbod; }
      { plugin = vim-devicons; }
      { plugin = vim-dispatch; }
      { plugin = vim-fireplace; }
      { plugin = vim-gitbranch; }
      { plugin = vim-hardtime; config = readFile ./config/vim-hardtime-config.vim; }
      { plugin = vim-polyglot; }
      { plugin = vim-repeat; }
      { plugin = vim-sensible; }
      { plugin = vim-signify; config = readFile ./config/vim-signify-config.vim; }
      { plugin = vim-startify; config = readFile ./config/vim-startify-config.vim; }
      { plugin = vim-tmux-navigator; }
      { plugin = vim-visual-multi; }
      { plugin = vim-which-key; }
      { plugin = vimsence; config = readFile ./config/vimsence-config.vim; }
      { plugin = vimspector; }
    ];
  };
}
