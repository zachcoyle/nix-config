{
  pkgs,
  lib,
}: let
  inherit (pkgs) vimPlugins;
  formatters = import ./formatters.nix {inherit pkgs;};
  fmt_table = name: value: ''
    ${name} = {${lib.concatStringsSep "," (map (x: "\"" + x.name + "\"") value)}}
  '';
in {
  enable = true;
  # editorConfig.enable = true;
  extraPlugins = with vimPlugins; [
    # TODO: watch for https://github.com/nix-community/nixvim/pull/667 to merge
    conform-nvim
    friendly-snippets
    nvim-autopairs
    nvim-treesitter-textobjects # TODO: needs module
    statuscol-nvim
    telescope-ui-select-nvim
    tint-nvim
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
    -- ufo
    -- TODO: figure out whether can move to options below
    vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
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
  '';

  options = {
    mouse = "a";
    number = true;
    relativenumber = true;
    clipboard = "unnamedplus";

    foldcolumn = "1";
    foldlevel = 99;
    foldlevelstart = 99;
    foldenable = true;
    signcolumn = "auto:5";

    guifont = "FiraCode Nerd Font:h14";
  };

  globals = {
    mapleader = " ";
  };

  keymaps = [
    {
      key = "<c-h>";
      action = "<c-w>h>";
    }
    {
      key = "<c-j>";
      action = "<c-w>j";
    }
    {
      key = "<c-k>";
      action = "<c-w>k";
    }
    {
      key = "<c-l>";
      action = "<c-w>l";
    }
    {
      key = "<leader>n";
      action = ":noh<cr>";
      options.silent = true;
    }
    {
      key = "<leader>a";
      action = ":lua vim.lsp.buf.code_action()<cr>";
      options.silent = true;
    }
    {
      key = "zR";
      action = ":lua require('ufo').openAllFolds()<cr>";
      options.silent = true;
    }
    {
      key = "zM";
      action = ":lua require('ufo').closeAllFolds()<cr>";
      options.silent = true;
    }
    {
      key = "zr";
      action = ":lua require('ufo').openFoldsExceptKinds()<cr>";
      options.silent = true;
    }
    {
      key = "zm";
      action = ":lua require('ufo').closeFoldsWith()<cr>";
      options.silent = true;
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
    cursorline.enable = true;
    dap = {
      enable = true;
      signs.dapBreakpoint.text = "";
      extensions = {
        dap-go.enable = true;
        dap-python = {
          enable = true;
          adapterPythonPath = "python";
        };
        dap-ui.enable = true;
        dap-virtual-text.enable = true;
      };
    };
    fugitive.enable = true;
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
    indent-blankline = {
      enable = true;
      indent = {
        # TODO: revisit this on a rainy day. I'd like this to match rainbow-delimiters, but muted
        # highlight = [
        #   "GruvboxRed"
        #   "GruvboxYellow"
        #   "GruvboxBlue"
        #   "GruvboxOrange"
        #   "GruvboxGreen"
        #   "GruvboxPurple"
        #   "GruvboxAqua"
        # ];
      };
    };
    leap.enable = true;
    lualine = {
      enable = true;
      theme = "gruvbox";
    };
    harpoon = {
      enable = true;
      enableTelescope = true;
      ## TODO: configure fully
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
          K = "hover"; # TODO on a rainy day, add mouse hover
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
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        lua-ls.enable = true;
        nil_ls.enable = true;
        pyright.enable = true;
        rust-analyzer.enable = true;
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
        # TODO: this should be handled automatically by the module system...
        {name = "nvim_lsp";}
        {name = "tabnine";}
        {name = "luasnip";}
        {name = "path";}
        {name = "buffer";}
      ];
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
    surround.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        # TODO:
        "<c-p>" = {
          action = "git_files";
          desc = "Telescope Git Files";
        };
        "<c-->" = {
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
        "<leader>ts" = {
          action = "treesitter";
          desc = "Telescope treesitter";
        };
      };
      extensions = {
        file_browser = {
          enable = true;
          hidden = true;
          hijackNetrw = true;
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
