{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nixvim.plugins = {
    barbar.enable = true;
    cmp = {
      enable = true;
      settings = {
        experimental = {
          ghost_text = true;
        };
        snippet.expand =
          # lua
          ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        widow = {
          completion.border = [
            "╔"
            "═"
            "╗"
            "║"
            "╝"
            "═"
            "╚"
            "║"
          ];
          documentation.border = [
            "╔"
            "═"
            "╗"
            "║"
            "╝"
            "═"
            "╚"
            "║"
          ];
        };
        mapping = {
          "<C-Space>" =
            # lua
            "cmp.mapping.complete()";
          "<C-d>" =
            # lua
            "cmp.mapping.scroll_docs(-4)";
          "<C-e>" =
            # lua
            "cmp.mapping.close()";
          "<C-f>" =
            # lua
            "cmp.mapping.scroll_docs(4)";
          "<CR>" =
            # lua
            "cmp.mapping.confirm({ select = true })";
          "<S-Tab>" =
            # lua
            ''cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" })'';
          "<Tab>" =
            # lua
            ''cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" })'';
        };
        sources = [
          {name = "nvim_lsp";}
          {name = "nvim_lsp_signature_help";}
          {name = "nvim_lsp_document_symbol";}
          {name = "nvim_lua";}
          {name = "cmp_tabnine";}
          {name = "luasnip";}
          {name = "path";}
          {name = "buffer";}
          {name = "emoji";}
        ];
      };
    };
    cmp-emoji.enable = true;
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
    comment.enable = true;
    conform-nvim = {
      enable = true;
      settings = {
        timeout_ms = 2000;
        format_on_save =
          # lua
          ''
            -- TODO: tighten this up
            function(bufnr)
              if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
                return
              end

              -- if slow_format_filetypes[vim.bo[bufnr].filetype] then
              --   return
              -- end

              local function on_format(err)
                if err and err:match("timeout$") then
                  -- slow_format_filetypes[vim.bo[bufnr].filetype] = true
                end
              end

              return { timeout_ms = 2000, lsp_fallback = false }, on_format
             end
          '';
        formatters_by_ft = {
          "*" = [
            # "codespell"
            "injected"
          ];
          "_" = ["trim_whitespace"];
          css = ["prettierd"];
          dart = ["dart_format"];
          go = ["gofumpt"];
          graphql = ["prettierd"];
          haskell = ["ormolu"];
          html = ["prettierd"];
          javascript = ["prettierd"];
          javascriptreact = ["prettierd"];
          json = [
            "fix_json"
            "prettierd"
          ];
          just = ["just"];
          kotlin = ["ktlint"];
          lua = ["stylua"];
          md = ["mdformat"];
          nix = ["alejandra"];
          python = [
            "ruff_fix"
            "ruff_format"
          ];
          rust = ["rustfmt"];
          swift = ["swift_format"];
          sh = ["beautysh"];
          sql = ["sql_formatter"];
          toml = ["taplo"];
          typescript = ["prettierd"];
          typescriptreact = ["prettierd"];
          vala = ["uncrustify"];
          vue = ["prettierd"];
          yaml = [
            "yamlfix"
            "yamlfmt"
          ];
        };
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
      adapters.executables = {
        lldb.command = "${lib.getExe' pkgs.lldb_17 "lldb-vscode"}";
      };
      configurations = {
        rust = [
          {
            name = "Launch";
            type = "lldb";
            request = "launch";
            program = {
              __raw =
                # lua
                ''
                  function()
                    return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
                  end
                '';
            };
            cwd = ''''${workspaceFolder}'';
            stopOnEntry = false;
            args = {};
            initCommands = {
              __raw =
                # lua
                ''
                  function()
                    -- Find out where to look for the pretty printer Python module
                    local rustc_sysroot = vim.fn.trim(vim.fn.system('rustc --print sysroot'))

                    local script_import = 'command script import "' .. rustc_sysroot .. '/lib/rustlib/etc/lldb_lookup.py"'
                    local commands_file = rustc_sysroot .. '/lib/rustlib/etc/lldb_commands'

                    local commands = {}
                    local file = io.open(commands_file, 'r')
                    if file then
                      for line in file:lines() do
                        table.insert(commands, line)
                      end
                      file:close()
                    end
                    table.insert(commands, 1, script_import)

                    return commands
                  end
                '';
            };
            env = {
              __raw =
                # lua
                ''
                  function()
                      local variables = {}
                      for k, v in pairs(vim.fn.environ()) do
                        table.insert(variables, string.format("%s=%s", k, v))
                      end
                      return variables
                    end
                '';
            };
          }
        ];
      };
    };
    diffview.enable = true;
    emmet.enable = true;
    firenvim = {
      enable = true;
      # TODO:
      # settings = {
      #   globalSettings = { };
      #   localSettings = { };
      # };
    };
    flash.enable = true;
    friendly-snippets.enable = true;
    fzf-lua = {
      enable = true;
      profile = "max-perf";
      keymaps = {
        "<leader>fp" = {
          action = "git_files";
          options = {
            desc = "Fzf-Lua Git Files";
            silent = true;
          };
          settings = {
            previewers.cat.cmd = "${pkgs.coreutils}/bin/cat";
            winopts.height = 0.5;
          };
        };
        "<leader>fg" = "live_grep";
      };
    };
    git-worktree = {
      enable = true;
      enableTelescope = true;
    };
    gitblame = {
      enable = true;
      settings = {
        delay = 600;
        virtualTextColumn = 80;
      };
    };
    gitsigns = {
      enable = true;
      settings = {
        signs = {
          add.text = "";
          change.text = "";
          changedelete.text = "";
          delete.text = "";
          topdelete.text = "";
          untracked.text = "";
        };
      };
    };
    harpoon = {
      enable = true;
      enableTelescope = true;
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
    helpview.enable = true;
    hmts.enable = true;
    indent-blankline.enable = true;
    lualine = {
      enable = true;
      settings.options = {
        theme = "gruvbox";
        component_separators = {
          left = "";
          right = "";
        };
        section_separators = {
          left = "";
          right = "";
        };
      };
    };
    lsp = {
      enable = true;
      inlayHints = true;
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
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
          gs = "signature_help";
        };
      };
      servers = {
        bashls.enable = true;
        biome.enable = true;
        clangd.enable = true;
        cssls.enable = true;
        dartls.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        hls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        kotlin_language_server.enable = true;
        lua_ls = {
          enable = true;
          settings = {
            diagnostics.globals = ["vim"];
            workspace = {
              ignoreDir = [
                ".vscode"
                ".direnv"
                ".devenv"
              ];
              library = [{__raw = ''vim.api.nvim_get_runtime_file("", true)'';}];
            };
          };
        };
        marksman.enable = true;
        nil_ls.enable = true;
        ruff_lsp.enable = true;
        rust_analyzer = {
          enable = true;
          installRustc = true;
          installCargo = true;
          settings = {
            cargo.features = "all";
            files = {
              excludeDirs = [
                ".direnv"
                ".devenv"
              ];
            };
            hover = {
              documentation = {
                enable = true;
                keywords.enable = true;
              };
              links.enable = true;
              memoryLayout.enable = true;
            };
          };
        };
        sourcekit.enable = false;
        tailwindcss.enable = true;
        ts_ls.enable = true;
        vala_ls.enable = pkgs.stdenv.isLinux;
        volar.enable = true;
        yamlls.enable = true;
        zls.enable = true;
      };
    };
    lsp-lines.enable = true;
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
    neogit = {
      enable = true;
      settings = {
        autoRefresh = true;
        integrations.diffview = true;
      };
    };
    # neotest = {
    #   enable = true;
    #   adapters = {
    #     bash.enable = true;
    #     jest.enable = true;
    #     python.enable = true;
    #     rust.enable = true;
    #     zig.enable = true;
    #   };
    # };
    noice = {
      enable = true;
      notify.enabled = false;
    };
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
    nvim-surround.enable = true;
    nvim-ufo = {
      enable = true;
      enableGetFoldVirtText = true;
      providerSelector =
        # lua
        ''
          function(bufnr, filetype, buftype)
            return {'treesitter', 'indent'}
          end
        '';
    };
    ollama = {
      enable = true;
      model = "yi-coder";
      url = "http://127.0.0.1:11434";
      extraOptions = {
        stream = true;
      };
    };
    otter = {
      enable = true;
      settings = {
        handle_leading_whitespace = true;
        buffers = {
          set_filetype = true;
          write_to_disk = true;
        };
        lsp.diagnostic_update_events = ["BufWritePost"];
      };
    };
    project-nvim = {
      enable = true;
      enableTelescope = true;
    };
    rainbow-delimiters.enable = true;
    refactoring.enable = true;
    telescope = {
      enable = true;
      settings.defaults = {
        layout_strategy = "flex";
      };
      keymaps = {
        "<c-p>" = {
          action = "git_files";
          options.desc = "Telescope Git Files";
        };
        "<c-->" = {
          action = "live_grep";
          options.desc = "Telescope Live Grep";
        };
        "<c-/>" = {
          action = "live_grep";
          options.desc = "Telescope Live Grep";
        };
        "<leader>ts" = {
          action = "live_grep";
          options.desc = "Telescope Live Grep";
        };
        "gr" = {
          action = "lsp_references";
          options.desc = "Telescope LSP References";
        };
        "<leader>tb" = {
          action = "buffers";
          options.desc = "Telescope Buffers";
        };
        "<leader>tt" = {
          action = "treesitter";
          options.desc = "Telescope Treesitter";
        };
      };
      extensions = {
        file-browser = {
          enable = true;
          settings = {
            hidden = false;
            hijack_netrw = true;
            auto_depth = true;
            depth = null;
            select_buffer = true;
          };
        };
        # frecency.enable = true;
        fzf-native.enable = true;
        media-files.enable = true;
        ui-select.enable = true;
        undo.enable = true;
        manix.enable = true;
      };
    };
    tmux-navigator.enable = true;
    todo-comments.enable = true;
    toggleterm = {
      enable = true;
      settings = {
        direction = "float";
        winbar.enabled = true;
        open_mapping = "[[<c-f>]]";
      };
    };
    treesitter = {
      enable = true;
      nixGrammars = true;
      nixvimInjections = true;
      folding = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
        incremental_selection = {
          enable = true;
          init_selection = "gnn";
          node_decremental = "grm";
          node_incremental = "grn";
          scope_incremental = "grc";
        };
      };
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
    web-devicons.enable = true;
    which-key.enable = true;
  };
}
