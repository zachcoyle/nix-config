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
    # TODO: write nixvim formatter module
    conform-nvim
    nvim-autopairs
  ];

  extraConfigLua = ''
    require("nvim-autopairs").setup {}

    require("conform").setup({
      format_on_save = {
        timeout_ms = 500,
        lsp_fallback = true,
      },
      formatters_by_ft = {
        ${(lib.concatStringsSep "," (lib.mapAttrsToList fmt_table formatters))}
      }
    })
  '';

  options = {
    mouse = "a";
    number = true;
    relativenumber = true;
    foldlevel = 20;
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
      options = {
        silent = true;
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
    fugitive.enable = true;
    gitblame = {
      enable = true;
      delay = 600;
    };
    gitsigns.enable = true;
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
      keymaps = {
        diagnostic = {
          "<leader>j" = "goto_next";
          "<leader>k" = "goto_prev";
        };
        lspBuf = {
          K = "hover";
          gd = "definition";
          gi = "implementation";
          gt = "type_definition";
        };
      };
      servers = {
        bashls.enable = true;
        cssls.enable = true;
        # denols.enable = true;
        eslint.enable = true;
        gopls.enable = true;
        html.enable = true;
        jsonls.enable = true;
        kotlin-language-server.enable = true;
        lua-ls.enable = true;
        nixd.enable = true;
        pyright.enable = true;
        rust-analyzer.enable = true;
        sourcekit.enable = true;
        tsserver.enable = true;
        # volar.enable = true;
        vuels.enable = true;
        yamlls.enable = true;
      };
    };
    lsp-format.enable = false;
    luasnip.enable = true;
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
    nvim-lightbulb.enable = true;
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
