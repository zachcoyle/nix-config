{
  pkgs,
  lib,
}: let
  inherit (pkgs) vimPlugins;
  formatters = {
    lua = [
      {
        name = "stylua";
        pkg = pkgs.stylua;
      }
    ];
    python = [
      {
        name = "ruff_fix";
        pkg = pkgs.ruff;
      }
      {
        name = "ruff_format";
        pkg = pkgs.ruff;
      }
    ];
    javascript = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    javascriptreact = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    typescript = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    typescriptreact = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    json = [
      {
        name = "fixjson";
        pkg = pkgs.nodePackages.fixjson;
      }
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    css = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    graphql = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    vue = [
      {
        name = "prettierd";
        pkg = pkgs.prettierd;
      }
    ];
    swift = [
      {
        name = "swift_format";
        pkg = pkgs.swift-format;
      }
    ];
    nix = [
      {
        name = "alejandra";
        pkg = pkgs.alejandra;
      }
    ];
    rust = [
      {
        name = "rustfmt";
        pkg = pkgs.rustfmt;
      }
    ];
    go = [
      {
        name = "gofumpt";
        pkg = pkgs.gofumpt;
      }
    ];
    just = [
      {
        name = "just";
        pkg = pkgs.just;
      }
    ];
    ktlint = [
      {
        name = "ktlint";
        pkg = pkgs.ktlint;
      }
    ];
    yaml = [
      {
        name = "yamlfix";
        pkg = pkgs.yamlfix;
      }
      {
        name = "yamlfmt";
        pkg = pkgs.yamlfmt;
      }
    ];
  };
  fmt_table = name: value: ''
    ${name} = {${lib.concatStringsSep "," (map (x: "\"" + x.name + "\"") value)}}
  '';
in {
  enable = true;

  # editorConfig.enable = true;

  extraPackages = with pkgs;
    [
      fd
      ripgrep

      tabnine

      rustc
      cargo
      lldb
      (php.withExtensions ({
        enabled,
        all,
      }:
        enabled ++ [all.xdebug]))
    ]
    ++ (map (x: x.pkg) (lib.flatten (lib.attrValues formatters)));

  extraPlugins = with vimPlugins; [
    # TODO: watch for https://github.com/nix-community/nixvim/pull/667 to merge
    conform-nvim
    friendly-snippets
    nvim-autopairs
    nvim-treesitter-textobjects # TODO: needs module
    statuscol-nvim
    telescope-ui-select-nvim
    tint-nvim
    # TODO: https://github.com/IndianBoy42/tree-sitter-just
  ];

  extraConfigLua = ''
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
    require("conform").setup({
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        ${(lib.concatStringsSep "," (lib.mapAttrsToList fmt_table formatters))}
      }
    })
    --------------------------------------
    require("telescope").load_extension("refactoring")
    --------------------------------------
    local tabnine = require('cmp_tabnine.config')

    tabnine:setup({
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = '..',
        ignored_file_types = {
          -- default is not to ignored_file_types
          -- uncomment to ignore in lua:
          -- lua = trouble
        },
        show_prediction_strength = true
    })

  '';

  options = {
    mouse = "a";
    number = true;
    relativenumber = true;
    clipboard = "unnamedplus";
    undofile = true;
    undodir = ["/Users/zcoyle/.config/nvim/.undo//"]; # TODO: xdg parameterize

    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    signcolumn = "auto:5";
    fillchars = {
      eob = " ";
      fold = " ";
      foldopen = "";
      foldsep = " ";
      foldclose = "";
    };

    guifont = "FiraCode Nerd Font:h13";
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
      action = "vim.lsp.buf.code_action";
      options = {
        silent = true;
        desc = "Code Actions";
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
      key = "<leader>rK";
      action = "require('rust-tools').hover_actions.hover_actions";
      options = {
        silent = false;
        desc = "Hover (Rust)";
      };
      lua = true;
    }
    {
      key = "<leader>rca";
      action = "require('rust-tools').code_action_group.code_action_group";
      options = {
        silent = false;
        desc = "Code Actions (Rust)";
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
  ];

  colorschemes = {
    gruvbox = {
      enable = true;
    };
  };

  plugins = {
    barbar.enable = true;
    barbecue.enable = true;
    cmp-nvim-lsp.enable = true;
    cmp-nvim-lsp-document-symbol.enable = true;
    cmp-nvim-lsp-signature-help.enable = true;
    cmp-nvim-lua.enable = true;
    cmp-path.enable = true;
    cmp-tabnine.enable = true;
    comment-nvim.enable = true;
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
            program = ''''${file}'';
            cwd = ''''${fileDirname}'';
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
              ''-dxdebug.client_port=''${port}''
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
    emmet = {
      enable = true;
    };
    fugitive.enable = true;
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
      enable = true;
      enableTelescope = true;
      # this can do a lot more, basically using it as glorified marks
      # FIXME: these keymaps arent working
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
          K = "hover"; # TODO on a rainy day, research mouse hover
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };
      servers = {
        bashls.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        intelephense.enable = true;
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        phpactor.enable = true;
        pyright.enable = true;
        # rust-analyzer.enable = true;
        ruff-lsp.enable = true;
        sourcekit.enable = true;
        tsserver.enable = true;
        # volar.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
      };
    };
    luasnip = {
      enable = true;
      fromVscode = [{}];
    };
    lspkind.enable = true;
    neogit = {
      enable = true;
      autoRefresh = true;
      # integrations.diffView = true;
      mappings = {
      };
    };
    noice.enable = true;
    notify.enable = true;
    nix.enable = true;
    nvim-cmp = {
      enable = true;
      completion.autocomplete = ["TextChanged"];
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
      data = "/Users/zcoyle/.cache/jdtls/workspace/"; # TODO: xdg parameterize
      configuration = "/Users/zcoyle/.cache/jdtls/config/"; # TODO: xdg parameterize
      initOptions = {
        bundles = [
          # FIXME: find better way to ascertain path
          "${pkgs.vscode-marketplace.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/server/com.microsoft.java.debug.plugin-0.44.0.jar"
        ];
      };
    };
    nvim-lightbulb = {
      enable = true;
      autocmd.enabled = true;
      virtualText.enabled = true;
      sign.enabled = false;
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
    rainbow-delimiters.enable = true;
    refactoring.enable = true;
    rust-tools = {
      enable = true;
      hoverActions.autoFocus = true;
      server = {
        files = {
          excludeDirs = [
            ".direnv"
          ];
        };
      };
      extraOptions = {
        dap = {
          adapter = with {base_path = "${pkgs.vscode-marketplace.vadimcn.vscode-lldb}/share/vscode/extensions/vadimcn.vscode-lldb";}; {
            # FIXME:
            # figuring this out thus far has been a living nightmare.
            # See: https://github.com/simrat39/rust-tools.nvim/wiki/Debugging
            # and: https://github.com/simrat39/rust-tools.nvim/blob/0cc8adab23117783a0292a0c8a2fbed1005dc645/lua/rust-tools/dap.lua#L8
            type = "server";
            port = "\${port}";
            host = "127.0.0.1";
            executable = {
              command = "${base_path}/adapter/codelldb";
              args = ["--liblldb" "${base_path}/lldb/lib/liblldb.dylib" "--port" "\${port}"];
            };
          };
        };
      };
    };
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
        # project-nvim.enable = true; # TODO: this is busted
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
      # hacky, as I stated above, this needs to be moved to nixvim
      moduleConfig = {
        textobjects = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = {
                query = "@class.inner";
                desc = "Select inner part of a class region";
              };
              "as" = {
                query = "@scope";
                query_group = "locals";
                desc = "Select language scope";
              };
            };
            selection_modes = {
              "@parameter.outer" = "v";
              "@function.outer" = "V";
              "@class.outer" = "<c-v>";
            };
            include_surrounding_whitespace = true;
          };
          swap = {
            enable = true;
            swap_next = {
              "<leader>a" = "@parameter.inner";
            };
            swap_previous = {
              "<leader>A" = "@parameter.inner";
            };
          };
          move = {
            enable = true;
            set_jumps = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = {
                query = "@class.outer";
                desc = "Next class start";
              };
              # "o" = "@loop.*"; # I use o too much to bind this. gotta come up with a different binding
              "]s" = {
                query = "@scope";
                query_group = "locals";
                desc = "Next scope";
              };
              "]z" = {
                query = "@fold";
                query_group = "folds";
                desc = "Next fold";
              };
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
            goto_next = {
              "]d" = "@conditional.outer";
            };
            goto_previous = {
              "[d" = "@conditional.outer";
            };
          };
          lsp_interop = {
            enable = true;
            border = "none";
            floating_preview_opts = {};
            peek_definition_code = {
              "<leader>df" = "@function.outer";
              "<leader>dF" = "@class.outer";
            };
          };
        };
      };
    };
    # treesitter-context.enable = true;
    treesitter-refactor = {
      enable = true;
      highlightDefinitions.enable = true;
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
