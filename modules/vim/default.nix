{ pkgs, home, programs, ... }:

with pkgs;
let
  sources = import ../../nix/sources.nix;
  nixpkgsMaster = import sources.nixpkgs {
    overlays = [ vimPlugins_overlay ];
    config = { };
  };

  neovim_nightly_overlay = import (builtins.fetchTarball {
    url = "https://github.com/mjlbach/neovim-nightly-overlay/archive/master.tar.gz";
  });

  vimPlugins_overlay = self: super:
    let
      inherit (super.vimUtils) buildVimPluginFrom2Nix;
    in
    {
      vimPlugins = super.vimPlugins // {

        galaxyline-nvim = buildVimPluginFrom2Nix {
          pname = "galaxyline-nvim";
          version = "2021-01-17";
          src = super.fetchFromGitHub {
            owner = "glepnir";
            repo = "galaxyline.nvim";
            rev = "64d6b8e31459057ba4f9b03a977fce0d2cc3d748";
            sha256 = "SuNo9aPxktdVZ9RtvlA7fN7w41hP26zuH9XW3fd7rPA=";
          };
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

        vim-dadbod-ui = buildVimPluginFrom2Nix {
          pname = "vim-dadbod-ui";
          version = "2020-10-29";
          src = super.fetchFromGitHub {
            owner = "kristijanhusak";
            repo = "vim-dadbod-ui";
            rev = "3f8f8563b123de8c6ed5d0ef4c997728c7455ea2";
            sha256 = "LjbvHjdDELUQ7Ho9Ntiam/Hym63g1LOxPUKvQk7Q01E=";
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

  pyls = python3Packages.python-language-server.overrideAttrs
    (oldAttrs: { doInstallCheck = false; });

  formatters = [
    gofumpt
    ktlint
    nixpkgs-fmt
    ocamlformat
    ormolu
    #nodePackages.prettier
    prettierPkgs
    python3Packages.black
    python3Packages.isort
    rubocop
    rustfmt
    scalafmt
    terraform
    uncrustify
  ];

  lsHelpers = [ ocamlPackages.merlin ];

  lspConfig = ''
    let g:LanguageClient_serverCommands = {
          \ 'c'               : ['${ccls}/bin/ccls'],
          \ 'clojure'         : ['${clojure-lsp}/bin/clojure-lsp'],
          \ 'cpp'             : ['${ccls}/bin/ccls'],
          \ 'dockerfile'      : ['${nodePackages.dockerfile-language-server-nodejs}/bin/docker-langserver', '--stdio'],
          \ 'go'              : ['${gopls}/bin/gopls'],
          \ 'haskell'         : ['${haskellPackages.haskell-language-server}/bin/haskell-language-server', '--lsp'],
          \ 'java'            : ['${jdtls}/bin/jdt-language-server'],
          \ 'javascript'      : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'javascriptreact' : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'json'            : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'kotlin'          : ['${nur.repos.zachcoyle.kotlin-language-server}/bin/kotlin-language-server'],
          \ 'lua'             : ['${lua53Packages.lua-lsp}/bin/lua-lsp'],
          \ 'nix'             : ['${rnix-lsp}/bin/rnix-lsp'],
          \ 'objc'            : ['${ccls}/bin/ccls'],
          \ 'ocaml'           : ['${nodePackages.ocaml-language-server}/bin/ocaml-language-server', '--stdio'],
          \ 'python'          : ['${pyls}/bin/pyls'],
          \ 'ruby'            : ['${solargraph}/bin/solargraph', 'stdio'],
          \ 'rust'            : ['${rust-analyzer}/bin/rust-analyzer'],
          \ 'scala'           : ['${metals}/bin/metals'],
          \ 'sh'              : ['${nodePackages.bash-language-server}/bin/bash-language-server', 'start'],
          \ 'swift'           : ['xcrun', '--toolchain', 'swift', 'sourcekit-lsp'],
          \ 'typescript'      : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'typescriptreact' : ['${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver'],
          \ 'vim'             : ['${nodePackages.vim-language-server}/bin/vim-language-server', '--stdio'],
          \ }
  '';

  nvimLSPConfig = ''
    packadd nvim-lspconfig

    lua << EOF
    local nvim_lsp = require'nvim_lsp'

    nvim_lsp.rnix.setup{
      cmd = { '${rnix-lsp}/bin/rnix-lsp' }
    }

    nvim_lsp.tsserver.setup{
      cmd = { '${nodePackages.typescript-language-server}/bin/typescript-language-server', '--stdio', '--tsserver-path', 'tsserver' },
      filetypes = { "json", "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" }
    }

    nvim_lsp.vimls.setup{
      cmd = { '${nodePackages.vim-language-server}/bin/vim-language-server', '--stdio' }
    }

    EOF
  '';

  dapConfig = ''
    packadd nvim-dap
    lua << EOF

    local dap = require('dap')
    dap.adapters.python = {
      type = 'executable',
      command = '${python3.withPackages (ps: [ ps.debugpy ])}/bin/python',
      args = { '-m', 'debugpy.adapter' }
    }

    dap.configurations.python = {
      {
        type = 'python',
        request = 'launch',
        name = "Launch File",
        program = "''${file}",
        pythonPath = function(adapter)
          return '${python3}/bin/python'
        end
      }
    }

    EOF
  '';

  galaxyline-config = ''
    lua << EOF
      ${builtins.readFile ./config/galaxyline-nvim-config.lua}
    EOF
  '';

in
{

  nixpkgs.overlays = [ neovim_nightly_overlay vimPlugins_overlay ];

  home.packages = formatters ++ lsHelpers;

  programs.neovim = {
    enable = true;
    vimAlias = true;
    withNodeJs = true;

    package = pkgs.neovim-nightly;
    extraConfig = builtins.readFile ./config/init.vim;

    plugins = with nixpkgsMaster.vimPlugins; with builtins; [
      { plugin = auto-pairs; }
      { plugin = barbar-nvim; }
      { plugin = colorizer; }
      { plugin = conjure; }
      { plugin = deol-nvim; }
      { plugin = deoplete-nvim; config = readFile ./config/deoplete-nvim-config.vim; }
      { plugin = direnv-vim; config = readFile ./config/direnv-vim-config.vim; }
      { plugin = editorconfig-vim; }
      { plugin = emmet-vim; config = readFile ./config/emmet-vim-config.vim; }
      { plugin = fugitive; }
      { plugin = fzf-vim; config = readFile ./config/fzf-vim-config.vim; }
      { plugin = galaxyline-nvim; config = galaxyline-config; }
      { plugin = gruvbox; config = readFile ./config/theme-config.vim; }
      { plugin = LanguageClient-neovim; config = (readFile ./config/LanguageClient-neovim-config.vim) + lspConfig; }
      { plugin = lf-vim; }
      #{
      #  plugin = lualine-nvim;
      #  config = ''
      #    lua << EOF
      #      local lualine = require('lualine')
      #      lualine.status()
      #      lualine.theme = 'gruvbox'
      #      lualine.extensions = { 'fzf' }
      #    EOF
      #  '';
      #}
      { plugin = neoformat; config = readFile ./config/neoformat-config.vim; }
      { plugin = nvim-dap; config = dapConfig + (readFile ./config/nvim-dap-config.vim); }
      { plugin = nvim-dap-virtual-text; }
      #{ plugin = nvim-lspconfig; config = nvimLSPConfig + (readFile ./config/nvim-lspconfig-config.vim); }
      { plugin = nvim-tree-lua; config = readFile ./config/nvim-tree-lua-config.vim; }
      { plugin = nvim-treesitter; config = readFile ./config/nvim-treesitter-config.vim; }
      {
        plugin = nvim-treesitter-textobjects;
        config = ''
          lua <<EOF
          require'nvim-treesitter.configs'.setup {
            textobjects = {
              select = {
                enable = true,
                keymaps = {
                  -- You can use the capture groups defined in textobjects.scm
                  ["af"] = "@function.outer",
                  ["if"] = "@function.inner",
                  ["ac"] = "@class.outer",
                  ["ic"] = "@class.inner",
                },
              },
            },
          }
          EOF
        '';
      }
      { plugin = nvim-web-devicons; }
      { plugin = rainbow; config = readFile ./config/rainbow-config.vim; }
      { plugin = scrollbar-nvim; config = readFile ./config/scrollbar-nvim-config.vim; }
      { plugin = surround; }
      { plugin = tabular; }
      { plugin = undotree; }
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
      { plugin = vimagit; }
      { plugin = vim-nix; }
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
