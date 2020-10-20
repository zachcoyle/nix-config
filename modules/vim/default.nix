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

        nvim-dap = buildVimPluginFrom2Nix {
          pname = "nvim-dap";
          version = "2020-10-09";
          src = super.fetchFromGitHub {
            owner = "mfussenegger";
            repo = "nvim-dap";
            rev = "aed68d514343428a622c3e6cc2a21e0b0e439cee";
            sha256 = "yMLexjkXdWf7VDrBwgIe7z+KnXBU2UOeoHgtTd2joyY=";
          };
        };

        nvim-dap-virtual-text = buildVimPluginFrom2Nix {
          pname = "nvim-dap-virtual-text";
          version = "2020-09-20";
          src = super.fetchFromGitHub {
            owner = "theHamsta";
            repo = "nvim-dap-virtual-text";
            rev = "251cebfa5cd41345dbf33db6d433c4ca7be38610";
            sha256 = "cMrkcZJ65zFXo9lxQF9ItFEfY0APVfgSYxnZdhktyTQ=";
          };
        };

        nvim-tree-lua = buildVimPluginFrom2Nix {
          pname = "nvim-tree-lua";
          version = "2020-10-14";
          src = super.fetchFromGitHub {
            owner = "kyazdani42";
            repo = "nvim-tree.lua";
            rev = "47cd138808fe51346483f8800b44d9a6f4c95626";
            sha256 = "udX5De9NIXvQG8xz1su3slF3vi+lLAGoOVolckHtLpo=";
          };
        };

        nvim-web-devicons = buildVimPluginFrom2Nix {
          pname = "nvim-web-devicons";
          version = "2020-10-14";
          src = super.fetchFromGitHub {
            owner = "kyazdani42";
            repo = "nvim-web-devicons";
            rev = "df7537b32ef6dcd100adcfcd921c614543997b88";
            sha256 = "iJBwRk5Bz+QGGqxWNMTdY4Yy/P+sQkwXmRQAjJVrR64=";
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
    nixpkgs-fmt
    ormolu
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
          \ 'dockerfile'      : ['${nodePackages_latest.dockerfile-language-server-nodejs}/bin/docker-langserver', '--stdio'],
          \ 'go'              : ['${gopls}/bin/gopls'],
          \ 'haskell'         : ['${haskellPackages.haskell-language-server}/bin/haskell-language-server', '--lsp'],
          \ 'javascript'      : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'javascriptreact' : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'json'            : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'nix'             : ['${rnix-lsp}/bin/rnix-lsp'],
          \ 'objc'            : ['${ccls}/bin/ccls'],
          \ 'python'          : ['${pyls}/bin/pyls'],
          \ 'ruby'            : ['${solargraph}/bin/solargraph', 'stdio'],
          \ 'rust'            : ['${rls}/bin/rls'],
          \ 'sh'              : ['${nodePackages_latest.bash-language-server}/bin/bash-language-server', 'start'],
          \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'typescript'      : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'typescriptreact' : ['${nodePackages_latest.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'vim'             : ['${nodePackages_latest.vim-language-server}/bin/vim-language-server', '--stdio'],
          \ }
  '';

  dapConfig = ''
    lua << EOF

    local dap = require('dap')
    dap.adapters.python = {
      type = 'executable';
      command = '${python3.withPackages (ps: [ ps.debugpy ])}/bin/python';
      args = { '-m', 'debugpy.adapter' };
    }
    EOF

    nnoremap <silent> <F5> :lua require'dap'.continue()<CR>
    nnoremap <silent> <F10> :lua require'dap'.step_over()<CR>
    nnoremap <silent> <F11> :lua require'dap'.step_into()<CR>
    nnoremap <silent> <F12> :lua require'dap'.step_out()<CR>
    nnoremap <silent> <leader>b :lua require'dap'.toggle_breakpoint()<CR>
    nnoremap <silent> <leader>B :lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>
    nnoremap <silent> <leader>lp :lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>
    nnoremap <silent> <leader>dr :lua require'dap'.repl.open()<CR>
    nnoremap <silent> <leader>dl :lua require'dap'.repl.run_last()<CR>
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
      #{ plugin = nvim-dap-virtual-text; }
      #{ plugin = nvim-dap; config = dapConfig; }
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
      { plugin = vim-devicons; }
      { plugin = vim-dispatch; }
      { plugin = vim-easymotion; }
      { plugin = vim-fireplace; }
      { plugin = vim-gitbranch; }
      { plugin = vim-hardtime; config = readFile ./config/vim-hardtime-config.vim; }
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
