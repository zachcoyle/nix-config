{
  pkgs,
  config,
}: let
  extension_path = "${pkgs.vscode-marketplace.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";
  codelldb_path = "${extension_path}/adapter/codelldb";
  liblldb_path = "${extension_path}/lldb/lib/liblldb.dylib"; # TODO: .so for linux
in {
  enable = true;
  enableMan = false;

  editorconfig.enable = true;

  extraPackages = with pkgs;
    [
      # util
      fd
      lazygit
      ripgrep
      tabnine
    ]
    ++ [
      # dap
      rustc
      # INFO: watch for this pr https://github.com/NixOS/nixpkgs/pull/264887
      # pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
      cargo
      lldb
      (php.withExtensions ({
        enabled,
        all,
      }:
        enabled ++ [all.xdebug]))
    ]
    ++ [
      # formatters
      alejandra
      biome
      beautysh
      prettierd
      codespell
      gofumpt
      just
      ktlint
      nodePackages.fixjson
      nodePackages.sql-formatter
      ruff
      rustfmt
      stylua
      swift-format
      # yamlfix
      yamlfmt
    ];

  extraPlugins = with pkgs.vimPlugins; [
    # TODO: https://github.com/IndianBoy42/tree-sitter-just
    friendly-snippets
    nvim-autopairs
    statuscol-nvim
    telescope-ui-select-nvim
    tint-nvim
    neorepl-nvim
    pkgs.rustaceanvim
    telescope_just
    sg-nvim
    yuck-vim
  ];

  extraConfigLua = ''
    vim.cmd [[ aunmenu PopUp.How-to\ disable\ mouse ]]
    vim.cmd [[ aunmenu PopUp.-1- ]]
    --------------------------------------
    require("nvim-autopairs").setup({})
    --------------------------------------
    require("telescope").setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })
    require("telescope").load_extension("ui-select")
    --------------------------------------
    local builtin = require("statuscol.builtin")
    require("statuscol").setup({
      relculright = true,
      segments = {
        { text = { builtin.foldfunc }, click = "v:lua.ScFa" },
        { text = { "%s" }, click = "v:lua.ScSa" },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa" },
      },
    })
    --------------------------------------
    require("tint").setup()
    --------------------------------------
    require("telescope").load_extension("refactoring")
    --------------------------------------
    -- require("dap.ext.vscode").load_launchjs(nil, { rt_lldb = { "rust" } })
    --------------------------------------
    -- INFO: watch for this pr https://github.com/NixOS/nixpkgs/pull/264887
    vim.g.rustaceanvim = {
      server = {
        settings = function()
        return {
          ['rust-analyzer'] = {
            files = {
              excludeDirs = {".direnv"},
              watcherExclude = {".direnv"},
            },
          },
        }
        end
      },
      --  dap = {
      --    adapter = require("rustaceanvim.dap").get_codelldb_adapter("${codelldb_path}", "${liblldb_path}"),
      -- },
    }

    --------------------------------------

    require("sg").setup {
      enable_cody = true
    }

    --------------------------------------
    if vim.fn.exists('g:neovide') ~= 0 then
        vim.g.neovide_transparency = 0.8
        vim.g.neovide_background_color = "${config.lib.stylix.colors.withHashtag.base00}"
    else
      vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
      vim.cmd [[ hi NonText guibg=NONE ctermbg=NONE ]]
      vim.cmd [[ hi SignColumn guibg=NONE ctermbg=NONE ]]
    end
  '';

  options = {
    mouse = "a";
    number = true;
    relativenumber = true;
    wrap = false;
    clipboard = "unnamedplus";
    undofile = true;
    undodir = ["${config.xdg.configHome}nvim/.undo//"];
    exrc = true; # (.exrc, .nvimrc, .nvim.lua)

    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    signcolumn = "yes:2";
    fillchars = {
      eob = " ";
      fold = " ";
      foldopen = "";
      foldsep = " ";
      foldclose = "";
    };

    guifont = "FiraCode Nerd Font:h10";
  };

  globals = {
    mapleader = " ";
  };

  keymaps = [
    {
      key = "<c-h>";
      action = "<c-w>h>";
      options.desc = "West";
    }
    {
      key = "<c-j>";
      action = "<c-w>j";
      options.desc = "South";
    }
    {
      key = "<c-k>";
      action = "<c-w>k";
      options.desc = "North";
    }
    {
      key = "<c-l>";
      action = "<c-w>l";
      options.desc = "East";
    }
    {
      key = "<leader>ch";
      action = ":noh<cr>";
      options = {
        silent = true;
        desc = "Clear Highlights";
      };
    }
    {
      key = "<leader>ca";
      action = ''
        function()
          if vim.bo.buftype == "rust"
          then
            vim.cmd.RustLsp('codeAction')
          else
            vim.lsp.buf.code_action()
          end
        end
      '';
      options = {
        silent = true;
        desc = "LSP Code Actions";
      };
      lua = true;
    }
    {
      key = "<leader>rn";
      action = "vim.lsp.buf.rename";
      options = {
        silent = true;
        desc = "LSP Rename";
      };
      lua = true;
    }
    {
      key = "zR";
      action = "require('ufo').openAllFolds";
      options = {
        silent = true;
        desc = "UFO Open All Folds";
      };
      lua = true;
    }
    {
      key = "zM";
      action = "require('ufo').closeAllFolds";
      options = {
        silent = true;
        desc = "UFO Close All Folds";
      };
      lua = true;
    }
    {
      key = "zr";
      action = "require('ufo').openFoldsExceptKinds";
      options = {
        silent = true;
        desc = "UFO Open Folds Except Kinds";
      };
      lua = true;
    }
    {
      key = "zm";
      action = "require('ufo').closeFoldsWith";
      options = {
        silent = true;
        desc = "Close Folds With";
      };
      lua = true;
    }
    {
      key = "<leader>dc";
      action = ":DapContinue<cr>";
      options = {
        silent = true;
        desc = "DAP Continue";
      };
    }
    {
      key = "<leader>dt";
      action = "function() if vim.bo.filetype == 'java' then vim.cmd('JdtUpdateDebugConfig') end; require('dapui').toggle() end";
      options = {
        silent = true;
        desc = "DAPUI Toggle";
      };
      lua = true;
    }
    {
      key = "<leader>th";
      action = ":Telescope harpoon marks<cr>";
      options = {
        silent = true;
        desc = "Telescope Harpoon Marks";
      };
    }
    {
      key = "<leader>tr";
      action = "require('refactoring').select_refactor";
      options = {
        silent = true;
        desc = "Telescope Refactor";
      };
      lua = true;
    }
    {
      key = "<leader>tu";
      action = "require('telescope').extensions.undo.undo";
      options = {
        silent = true;
        desc = "Telescope Undo";
      };
      lua = true;
    }
    {
      key = "<leader>tf";
      action = "require('telescope').extensions.file_browser.file_browser";
      options = {
        silent = true;
        desc = "Telecope File Browser";
      };
      lua = true;
    }
    {
      key = "<leader>td";
      action = ":TodoTelescope<cr>";
      options = {
        silent = true;
        desc = "Telescope Todos";
      };
    }
    {
      key = "<leader>tp";
      action = ":Telescope projects<cr>";
      options = {
        silent = true;
        desc = "Telescope Projects";
      };
    }
    {
      key = "<leader>tj";
      action = "require('just').just";
      lua = true;
    }
    {
      key = "]t";
      action = "require('todo-comments').jump_next";
      options = {
        silent = true;
        desc = "Jump to Next TODO";
      };
      mode = "n";
      lua = true;
    }
    {
      key = "[t";
      action = "require('todo-comments').jump_prev";
      options = {
        silent = true;
        desc = "Jump to Previous TODO";
      };
      mode = "n";
      lua = true;
    }
    {
      key = "K";
      action = ''
        function()
          if vim.bo.buftype == "rust"
          then
            vim.cmd.RustLsp { 'hover', 'actions' }
          else
            vim.cmd[[ Lspsaga hover_doc ]]
          end
        end
      '';
      options = {
        silent = false;
        desc = "LSP Hover";
      };
      lua = true;
    }
    {
      key = "<leader>di";
      action = "require('dap.ui.widgets').hover";
      options = {
        silent = true;
        desc = "DAPUI Hover/Inspect";
      };
      lua = true;
    }
    {
      key = ";";
      action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next";
      options = {
        silent = true;
        desc = "Repeat Last Move Next";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = ",";
      action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous";
      options = {
        silent = true;
        desc = "Repeat Last Move Previous";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = "f";
      action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_f";
      options = {
        silent = true;
        desc = "fancy f";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = "F";
      action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_F";
      options = {
        silent = true;
        desc = "fancy F";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = "t";
      action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_t";
      options = {
        silent = true;
        desc = "fancy t";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = "T";
      action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_T";
      options = {
        silent = true;
        desc = "fancy T";
      };
      lua = true;
      mode = ["n" "x" "o"];
    }
    {
      key = "<leader>go";
      action = "require('neogit').open";
      options = {
        silent = true;
        desc = "Open Neogit";
      };
      lua = true;
      mode = ["n"];
    }
    {
      key = "<leader>nb";
      action = ":Navbuddy<cr>";
      options = {
        silent = true;
        desc = "Open Navbuddy";
      };
    }
  ];

  colorschemes = {
    gruvbox = {
      enable = true;
    };
  };

  plugins = {
    barbar.enable = true;
    # barbecue.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp-tabnine = {
      enable = true;
      extraOptions = {
        max_lines = 1000;
        max_num_results = 2;
        sort = true;
        run_on_every_keystroke = true;
        snippet_placeholder = "..";
        ignored_file_types = {};
        show_prediction_strength = true;
      };
    };
    comment-nvim.enable = true;
    conform-nvim = {
      enable = true;
      formatOnSave = {};
      formattersByFt = {
        "*" = ["codespell" "injected"];
        "_" = ["trim_whitespace"];
        css = ["prettierd"];
        go = ["gofumpt"];
        graphql = ["prettierd"];
        javascript = ["prettierd"];
        javascriptreact = ["prettierd"];
        json = ["fix_json" "prettierd"];
        just = ["just"];
        kotlin = ["ktlint"];
        lua = ["stylua"];
        nix = ["alejandra"];
        python = ["ruff_fix" "ruff_format"];
        rust = ["rustfmt"];
        swift = ["swift_format"];
        sh = ["beautysh"];
        sql = ["sql_formatter"];
        typescript = ["prettierd"];
        typescriptreact = ["prettierd"];
        vue = ["prettierd"];
        yaml = ["yamlfix" "yamlfmt"];
      };
    };
    crates-nvim.enable = true;
    cursorline.enable = true;
    dap = {
      enable = true;
      signs.dapBreakpoint.text = "";
      extensions = {
        dap-go.enable = true;
        dap-python = {
          enable = true;
          adapterPythonPath = "python";
        };
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
      adapters = {
        executables = {
          php = {
            command = "${pkgs.nodejs}/bin/node";
            args = ["${pkgs.vscode-marketplace.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js"];
          };
        };
      };
      configurations = {
        php = [
          {
            name = "Listen for Xdebug";
            type = "php";
            request = "launch";
            port = 9003;
            log = true;
          }
          {
            name = "Launch currently open script";
            type = "php";
            request = "launch";
            program = "\${file}";
            cwd = "\${fileDirname}";
            port = 0;
            runtimeArgs = ["-dxdebug.start_with_request=yes"];
            env = {
              XDEBUG_MODE = "debug,develop";
              XDEBUG_CONFIG = ''client_port=''${port}'';
            };
            ignoreExceptions = ["IgnoreException"];
          }
          {
            name = "Launch Built-in web server";
            type = "php";
            request = "launch";
            runtimeArgs = [
              "-dxdebug.mode=debug"
              "-dxdebug.start_with_request=yes"
              "-dxdebug.client_port=\${port}"
              "-S"
              "localhost:0"
            ];
            program = "";
            cwd = "''\${workspaceRoot}";
            port = 0;
            serverReadyAction = {
              pattern = "Development Server \\(http://localhost:([0-9]+)\\) started";
              uriFormat = "http://localhost:%s";
              action = "openExternally";
            };
          }
        ];
      };
    };
    diffview.enable = true;
    emmet = {
      enable = true;
    };
    git-worktree = {
      enable = true;
      enableTelescope = true;
    };
    gitblame = {
      enable = true;
      delay = 600;
    };
    gitsigns = {
      enable = true;
      signs = {
        add.text = "";
        change.text = "";
        changedelete.text = "";
        delete.text = "";
        topdelete.text = "";
        untracked.text = "";
      };
    };
    indent-blankline.enable = true;
    leap.enable = true;
    lualine = {
      enable = true;
      theme = "gruvbox";
    };
    harpoon = {
      enable = false;
      enableTelescope = true;
      # this can do a lot more, basically using it as glorified marks rn
      keymaps = {
        addFile = "<leader>hh";
        navFile = {
          # "1" = "<C-j>";
          # "2" = "<C-k>";
          # "3" = "<C-l>";
          # "4" = "<C-m>";
        };
        navNext = "<leader>hn";
        navPrev = "<leader>hp";
        cmdToggleQuickMenu = "<leader>hd";
        gotoTerminal = {
          # "1" = "<C-j>";
          # "2" = "<C-k>";
          # "3" = "<C-l>";
          # "4" = "<C-m>";
        };
      };
    };
    hmts.enable = true;
    lsp = {
      enable = true;
      preConfig = ''
        vim.fn.sign_define(
          "DiagnosticSignError",
          { texthl = "DiagnosticSignError", text = "", numhl = "DiagnosticSignError" }
        )
        vim.fn.sign_define(
          "DiagnosticSignWarn",
          { texthl = "DiagnosticSignWarn", text = "", numhl = "DiagnosticSignWarn" }
        )
        vim.fn.sign_define(
          "DiagnosticSignHint",
          { texthl = "DiagnosticSignHint", text = "", numhl = "DiagnosticSignHint" }
        )
        vim.fn.sign_define(
          "DiagnosticSignInfo",
          { texthl = "DiagnosticSignInfo", text = "", numhl = "DiagnosticSignInfo" }
        )
      '';
      keymaps = {
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        lspBuf = {
          # K = "hover"; # TODO on a rainy day, research mouse hover
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          gs = "signature_help";
        };
      };
      servers = {
        bashls.enable = true;
        biome.enable = true;
        csharp-ls.enable = pkgs.stdenv.isLinux;
        cssls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        # intelephense.enable = true;
        # jsonls.enable = true;
        kotlin-language-server.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        phpactor.enable = true;
        pyright.enable = true;
        ruff-lsp.enable = true;
        sourcekit.enable = true;
        tsserver.enable = true;
        volar.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
      };
    };
    luasnip = {
      enable = true;
      fromVscode = [{}];
    };
    lspkind.enable = true;
    lspsaga = {
      enable = true;
      lightbulb = {
        enable = true;
        sign = true;
        virtualText = false;
      };
      extraOptions = {
        symbol_in_winbar = {
          enable = false;
        };
      };
    };
    navbuddy = {
      enable = true;
      lsp.autoAttach = true;
    };
    navic = {
      enable = true;
      click = true;
      highlight = true;
      lazyUpdateContext = false;
      lsp.autoAttach = true;
    };
    neogit = {
      enable = true;
      autoRefresh = true;
      integrations.diffview = true;
    };
    noice.enable = true;
    notify.enable = true;
    nix.enable = true;
    nvim-colorizer = {
      enable = true;
      userDefaultOptions = {
        AARRGGBB = true;
        css = true;
        hsl_fn = true;
        names = true;
        RGB = true;
        rgb_fn = true;
        RRGGBB = true;
        RRGGBBAA = true;
        virtualtext = "virtualtext";
      };
    };
    nvim-cmp = {
      enable = true;
      completion.autocomplete = ["TextChanged"];
      snippet.expand = "luasnip";
      mapping = {
        "<CR>" = "cmp.mapping.confirm({ select = true })";
        "<Tab>" = {
          action = ''
            function(fallback)
              local luasnip = require("luasnip")
              local check_backspace = function()
                local col = vim.fn.col "." - 1
                  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
                end
              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.expandable() then
                luasnip.expand()
              elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
              elseif check_backspace() then
                fallback()
              else
                fallback()
              end
            end
          '';
          modes = ["i" "s"];
        };
      };
      autoEnableSources = true;
      sources = [
        # INFO: this should be handled automatically by the module system...
        {name = "nvim_lsp";}
        {name = "nvim_lsp_signature_help";}
        {name = "nvim_lsp_document_symbol";}
        {name = "nvim_lua";}
        {name = "cmp_tabnine";}
        {name = "luasnip";}
        {name = "path";}
        {name = "buffer";}
      ];
    };
    nvim-jdtls = {
      enable = true;
      data = "${config.xdg.cacheHome}/jdtls/workspace/";
      configuration = "${config.xdg.cacheHome}/jdtls/config";
      initOptions = {
        bundles = let
          base_path = "${pkgs.vscode-marketplace.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug";
          package_json = builtins.fromJSON (builtins.readFile "${base_path}/package.json");
          jar_paths = builtins.map (e: "${base_path}/${e}") package_json.contributes.javaExtensions;
        in
          jar_paths;
      };
    };
    nvim-ufo = {
      enable = true;
      enableGetFoldVirtText = true;
      providerSelector = ''
        function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'}
        end
      '';
    };
    project-nvim.enable = true;
    rainbow-delimiters.enable = true;
    refactoring.enable = true;
    surround.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        "<c-p>" = {
          action = "git_files";
          desc = "Telescope Git Files";
        };
        "<c-->" = {
          action = "live_grep";
          desc = "Telescope Live Grep";
        };
        "<c-_>" = {
          action = "live_grep";
          desc = "Telescope Live Grep";
        };
        "<leader>ts" = {
          action = "live_grep";
          desc = "Telescope Live Grep";
        };
        "gr" = {
          action = "lsp_references";
          desc = "Telescope LSP References";
        };
        "<leader>tb" = {
          action = "buffers";
          desc = "Telescope Buffers";
        };
        "<leader>tt" = {
          action = "treesitter";
          desc = "Telescope Treesitter";
        };
      };
      extensions = {
        file_browser = {
          enable = true;
          hidden = false;
          hijackNetrw = true;
          autoDepth = true;
          depth = null;
          selectBuffer = true;
        };
        frecency.enable = true;
        fzf-native.enable = true;
        media_files.enable = true;
        project-nvim.enable = true;
        undo.enable = true;
      };
    };
    tmux-navigator.enable = true;
    todo-comments.enable = true;
    toggleterm = {
      enable = true;
      direction = "float";
      winbar.enabled = true;
      openMapping = "<c-f>";
    };
    treesitter = {
      enable = true;
      ensureInstalled = "all";
      folding = true;
      nixvimInjections = true;
      moduleConfig = {};
    };
    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
    };
    treesitter-textobjects = {
      enable = true;
      lspInterop = {
        enable = true;
        border = "double";
        floatingPreviewOpts = {};
        peekDefinitionCode = {
          "<leader>df" = "@function.outer";
          "<leader>dF" = "@class.outer";
        };
      };
      move = {
        enable = true;
        setJumps = true;
        gotoNextStart = {
          "]m" = "@function.outer";
          "]]" = {
            query = "@class.outer";
            desc = "Next class start";
          };
          "<leader>o" = "@loop.*";
          "]s" = {
            query = "@scope";
            queryGroup = "locals";
            desc = "Next scope";
          };
          "]z" = {
            query = "@fold";
            queryGroup = "folds";
            desc = "Next fold";
          };
        };
        gotoNextEnd = {
          "]M" = "@function.outer";
          "[[" = "@class.outer";
        };
        gotoPreviousEnd = {
          "[M" = "@function.outer";
          "[]" = "@class.outer";
        };
        gotoNext = {
          "]d" = "@conditional.outer";
        };
        gotoPrevious = {
          "[d" = "@conditional.outer";
        };
      };
      select = {
        enable = true;
        lookahead = true;
        includeSurroundingWhitespace = true;
        keymaps = {
          "ao" = "@loop.outer";
          "io" = "@loop.inner";
          "af" = "@function.outer";
          "if" = "@function.inner";
          "ac" = "@class.outer";
          "ic" = {
            query = "@class.inner";
            desc = "Select inner part of a class region";
          };
          "as" = {
            query = "@scope";
            queryGroup = "locals";
            desc = "Select language scope";
          };
        };
        selectionModes = {
          "@parameter.outer" = "v";
          "@function.outer" = "V";
          "@class.outer" = "<c-v>";
        };
      };
      swap = {
        enable = true;
        swapNext = {
          "<leader>a" = "@parameter.inner";
        };
        swapPrevious = {
          "<leader>A" = "@parameter.inner";
        };
      };
    };
    trouble.enable = true;
    ts-autotag.enable = true;
    ts-context-commentstring.enable = true;
    vim-matchup = {
      enable = true;
      enableSurround = true;
      treesitterIntegration.enable = true;
    };
    which-key = {
      enable = true;
    };
  };
}
