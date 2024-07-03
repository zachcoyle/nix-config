{
  pkgs,
  lib,
  config,
}:
let
  inherit (config.lib.stylix.colors) withHashtag;
in
{
  enable = true;

  package = pkgs.neovim;

  enableMan = false;

  luaLoader.enable = true;

  editorconfig.enable = true;

  extraPackages =
    with pkgs;
    [
      # utility
      fd
      lazygit
      ripgrep
      tabnine
      # dap
      lldb
      (php.withExtensions ({ enabled, all }: enabled ++ [ all.xdebug ]))
      # formatters
      alejandra
      biome
      beautysh
      prettierd
      codespell
      gofumpt
      just
      ktlint
      mdformat
      nodePackages.fixjson
      nodePackages.sql-formatter
      ruff
      rustfmt
      stylua
      # swift-format
      taplo
      # yamlfix
      yamlfmt
    ]
    # FIXME: this should also work on darwin
    ++ (lib.optionals pkgs.stdenv.isLinux [ pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter ]);

  extraPlugins = with pkgs.vimPlugins; [
    dropbar-nvim
    neorepl-nvim
    nvim-autopairs
    sg-nvim
    statuscol-nvim
    telescope_just
    tint-nvim
    yuck-vim
    firenvim
  ];

  extraConfigLua =
    '''' # lua
    + ''
      vim.cmd [[ aunmenu PopUp.How-to\ disable\ mouse ]]
      vim.cmd [[ aunmenu PopUp.-1- ]]
      --------------------------------------
      require("nvim-autopairs").setup({})
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
      require("sg").setup({
        enable_cody = true,
      })

      --------------------------------------
      -- make telescope projects appear when started without args
      vim.api.nvim_create_autocmd("UIEnter", {
        group = vim.api.nvim_create_augroup("Dashboard", { clear = true }),
        callback = function()
          if
            vim.fn.argc() == 0
            and vim.api.nvim_buf_line_count(0) == 1
            and vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == ""
          then
            require("telescope").extensions.projects.projects({})
          end
        end,
      })

      local dropbar_sources = require("dropbar.sources")
      local dropbar_utils = require("dropbar.utils")

      require("dropbar").setup({
        bar = {
          sources = {
            dropbar_utils.source.fallback({
              dropbar_sources.lsp,
              dropbar_sources.treesitter,
            }),
          },
        },
      })

      --------------------------------------
      local highlight = {
        "RainbowYellow",
        "RainbowBlue",
        "RainbowOrange",
        "RainbowGreen",
        "RainbowViolet",
        "RainbowCyan",
        "RainbowRed",
      }

      local hooks = require "ibl.hooks"
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
          vim.api.nvim_set_hl(0, "RainbowRed", { fg = "${withHashtag.base08}" })
          vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "${withHashtag.base0A}" })
          vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "${withHashtag.base0D}" })
          vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "${withHashtag.base09}" })
          vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "${withHashtag.base0B}" })
          vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "${withHashtag.base0E}" })
          vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "${withHashtag.base0C}" })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require("ibl").setup { scope = { highlight = highlight } }

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)

      --------------------------------------
      vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
        pattern = {"*"},
        callback = function(ev)
        -- TODO: improve this later by getting 
        -- all the current injections of the current
        -- buffer from the data returned by:
        -- vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] -- (probably can peek inside ev to get current buf)
          require("otter").activate({ "javascript", "python", "bash", "css", "lua", "rust", "haskell"}, true, true, nil)
        end
      })
    ''
    + (
      # TODO: all the neovide config could stand to be be tightened up
      if pkgs.stdenv.isDarwin then
        # lua 
        ''
          -- Helper function for transparency formatting
          local alpha = function()
            return string.format("%x", math.floor(255 * vim.g.transparency or 0.8))
          end
          -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
          vim.g.neovide_transparency = 0.0
          vim.g.transparency = 0.8
          vim.g.neovide_background_color = "${withHashtag.base00}" .. alpha()
        ''
      else
        # lua
        ''
          if vim.fn.exists('g:neovide') ~= 0 then
              vim.g.neovide_transparency = 0.8
              vim.g.neovide_background_color = "${withHashtag.base00}"
          else
            vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
            vim.cmd [[ hi NonText guibg=NONE ctermbg=NONE ]]
            vim.cmd [[ hi SignColumn guibg=NONE ctermbg=NONE ]]
          end

        ''
    );

  extraConfigLuaPre = # lua
    ''
      local Terminal = require("toggleterm.terminal").Terminal

      local _gitui = Terminal:new({ cmd = "gitui", direction = "float", hidden = true })

      function _gitui_toggle()
        _gitui:toggle()
      end
    '';

  extraConfigLuaPost =
    if pkgs.stdenv.isLinux then
      # lua
      ''
        vim.notify = function(msg, level, opts)
          local log_level = {
            [vim.log.levels.DEBUG] = 'low',
            [vim.log.levels.ERROR] = 'critical',
            [vim.log.levels.INFO] = 'normal',
            [vim.log.levels.TRACE] = 'normal',
            [vim.log.levels.WARN] = 'normal',
          }
          vim.system({'notify-send', msg, '-u', log_level[level], '-e', '-i', '${../../../../theme/neovim-mark.svg}'})
        end
      ''
    # TODO: darwin
    else
      # lua
      '''';

  options =
    {
      clipboard = "unnamedplus";
      exrc = true; # (.exrc, .nvimrc, .nvim.lua)
      fillchars = {
        eob = " ";
        fold = " ";
        foldopen = "";
        foldsep = " ";
        foldclose = "";
      };
      foldcolumn = "1";
      foldenable = true;
      foldlevel = 99;
      foldlevelstart = 99;
      mouse = "a";
      mousemoveevent = true;
      number = true;
      relativenumber = true;
      scrolloff = 4;
      shada = "!,'100,<50,s10";
      signcolumn = "yes:2";
      undodir = [ "${config.xdg.stateHome}/nvim/.undo//" ];
      undofile = true;
      wrap = false;
    }
    // (
      if pkgs.stdenv.isDarwin then
        { guifont = "FiraCode Nerd Font:h13"; }
      else
        { guifont = "FiraCode Nerd Font:h10"; }
    );

  globals = {
    mapleader = " ";
    neovide_hide_mouse_when_typing = true;
    neovide_unlink_border_highlights = true;
  };

  keymaps = import ./keymaps.nix;

  colorschemes = {
    gruvbox = {
      enable = true;
    };
  };

  plugins = import ./plugins.nix { inherit pkgs lib config; };
}
