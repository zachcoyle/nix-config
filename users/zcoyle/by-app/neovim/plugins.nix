{
  pkgs,
  config,
  ...
}: {
  barbar.enable = true;
  barbecue.enable = true;
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
  friendly-snippets.enable = true;
  git-worktree = {
    enable = true;
    enableTelescope = true;
  };
  gitblame = {
    enable = true;
    delay = 600;
    virtualTextColumn = 80;
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
      # ccls.enable = true;
      clangd.enable = true;
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
      # nixd.enable = true;
      phpactor.enable = true;
      pyright.enable = true;
      ruff-lsp.enable = true;
      sourcekit.enable = pkgs.stdenv.isDarwin;
      tsserver.enable = true;
      volar.enable = true;
      vuels.enable = true;
      yamlls.enable = true;
      zls.enable = true;
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
  neogit = {
    enable = true;
    autoRefresh = true;
    integrations.diffview = true;
  };
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
      {name = "nvim_lsp";}
      {name = "nvim_lsp_signature_help";}
      {name = "nvim_lsp_document_symbol";}
      {name = "nvim_lua";}
      {name = "cmp_tabnine";}
      {name = "luasnip";}
      {name = "path";}
      {name = "buffer";}
      {name = "emoji";}
      {name = "cmp_ai";}
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
  ollama = {
    enable = true;
    model = "mistral";
    url = "http://127.0.0.1:11434";
    extraOptions = {
      stream = true;
    };
  };
  project-nvim.enable = true;
  rainbow-delimiters.enable = true;
  refactoring.enable = true;
  rustaceanvim = {
    # TODO: dap still not working right
    enable = true;
    extraOptions = {
      rust-analyzer = {
        files = {
          excludeDirs = [".direnv"];
          watcherExclude = [".direnv"];
        };
      };
    };
  };
  surround.enable = true;
  telescope = {
    enable = true;
    defaults = {
      layout_strategy = "flex";
    };
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
      # frecency.enable = true;
      fzf-native.enable = true;
      media_files.enable = true;
      project-nvim.enable = true;
      ui-select.enable = true;
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
}
