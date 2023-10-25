{
  # editorConfig.enable = true;
  enable = true;

  options = {
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
  ];

  colorschemes = {
    gruvbox = {
      enable = true;
    };
  };
  plugins = {
    barbar.enable = true;
    barbecue.enable = true;
    chadtree.enable = true;
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
    lsp-format.enable = true;
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
    rainbow-delimiters.enable = true;
    surround.enable = true;
    telescope = {
      enable = true;
      keymaps = {
        "<C-p>" = {
          action = "git_files";
          desc = "Telescope Git Files";
        };
      };
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
    which-key = {
      enable = true;
    };
  };
}
