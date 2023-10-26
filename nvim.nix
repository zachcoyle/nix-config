{
  # editorConfig.enable = true;
  enable = true;

  options = {
    number = true;
    relativenumber = true;
    foldlevel = 20;
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
    # {
    #   key = "<c-n>";
    #   action = ":noh<cr>";
    # }
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
    dap.enable = true; ## TODO: configure fully
    gitblame = {
      enable = true;
      delay = 600;
    };
    gitsigns.enable = true;
    lualine = {
      enable = true;
      theme = "gruvbox";
    };
    lsp = {
      enable = true;
      servers = {
        bashls.enable = true;
        cssls.enable = true;
        denols.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        lua-ls.enable = true;
        nixd.enable = true;
        pyright.enable = true;
        rust-analyzer.enable = true;
        sourcekit.enable = true;
        tsserver.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
      };
    };
    lsp-format.enable = false;
    # TODO: write neoformat module
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
    };
    nvim-lightbulb.enable = true;
    rainbow-delimiters.enable = true;
    surround.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        "<c-p>" = {
          action = "git_files";
          desc = "Telescope Git Files";
        };
        "<c-_>" = {
          action = "live_grep";
          desc = "Telescope Live Grep";
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
        # project-nvim.enable = true;
        # undo.enable = true;
      };
    };
    tmux-navigator.enable = true;
    todo-comments.enable = true;
    toggleterm = {
      enable = true;
      winbar.enabled = true;
      openMapping = "<c-f>";
    };
    treesitter = {
      ## TODO: configure fully
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
    undotree.enable = true;
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
