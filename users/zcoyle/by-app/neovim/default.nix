{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.lib.stylix.colors) withHashtag;
in {
  imports = [
    ./plugins.nix
    ./keymaps.nix
  ];

  programs.nixvim = {
    enable = true;

    package = pkgs.neovim;

    enableMan = false;

    luaLoader.enable = true;

    editorconfig.enable = true;

    performance.byteCompileLua = {
      enable = true;
      configs = true;
      initLua = true;
      nvimRuntime = true;
      plugins = true;
    };

    extraFiles = {
      "queries/rust/injections.scm".text =
        # scheme
        ''
          ;; extends

          ; vizia - const STYLE: &str = r#"<css here>"#;
          (const_item
            name: (_) @n
            type: (_) @t
            value: (raw_string_literal
              (string_content) @injection.content
              (#set! injection.language "css"))
            (#match? @n "STYLE")
            (#match? @t "&str"))

          ; sqlx - sqlx::query(r#"<sql here>");
          (call_expression
            function: (scoped_identifier
                        path: (identifier) @p
                        name: (identifier) @n)
            arguments: (arguments
                         (raw_string_literal
                           (string_content) @injection.content
                           (#set! injection.language "sql")))
            (#match? @p "sqlx")
            (#match? @n "query"))

          ; sqlx - sqlx::query_as!(r#"<sql here>");
          ; FIXME: this one is sorta flakey w/highlighting
          (call_expression function:
            (field_expression value:
              (macro_invocation macro:
                (scoped_identifier
                  path: (identifier) @p
                  name: (identifier) @n)
                 (token_tree
                   (raw_string_literal
                     (string_content) @injection.content
                     (#set! injection.language "sql")))))
            (#match? @p "sqlx")
            (#match? @n "query_as"))
        '';
    };

    extraPackages = with pkgs;
      [
        # utility
        fd
        lazygit
        ripgrep
        tabnine

        # dap
        lldb

        # formatters
        alejandra
        biome
        beautysh
        prettierd
        codespell
        dart
        gofumpt
        just
        ktlint
        mdformat
        nodePackages.fixjson
        nodePackages.sql-formatter
        ormolu
        ruff
        rustfmt
        stylua
        # swift-format
        taplo
        uncrustify
        # yamlfix
        yamlfmt
      ]
      # FIXME: this should also work on darwin
      ++ (lib.optionals pkgs.stdenv.isLinux [pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter]);

    extraPlugins = with pkgs.vimPlugins; [
      dropbar-nvim
      neorepl-nvim
      nvim-autopairs
      statuscol-nvim
      telescope_just
      tint-nvim
    ];

    extraConfigLua =
      # lua
      ''
        vim.cmd [[ aunmenu PopUp.How-to\ disable\ mouse ]]
        vim.cmd [[ aunmenu PopUp.-2- ]]
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

        -- FIXME: temp junky fix for neovide theme on darwin

        local alpha = function()
          return string.format("%x", math.floor((255 * vim.g.transparency) or 0.8))
        end


        if vim.fn.exists('g:neovide') ~= 0 then
          vim.g.neovide_transparency = 0.8
          vim.g.neovide_background_color = "${withHashtag.base00}" .. alpha()
          vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
          vim.cmd [[ hi NonText guibg=NONE ctermbg=NONE ]]
          vim.cmd [[ hi SignColumn guibg=NONE ctermbg=NONE ]]
        else
          vim.cmd [[ hi Normal guibg=NONE ctermbg=NONE ]]
          vim.cmd [[ hi NonText guibg=NONE ctermbg=NONE ]]
          vim.cmd [[ hi SignColumn guibg=NONE ctermbg=NONE ]]
        end
      '';

    extraConfigLuaPre =
      # lua
      ''
        local Terminal = require("toggleterm.terminal").Terminal

        local _gitui = Terminal:new({ cmd = "gitui", direction = "float", hidden = true })

        function _gitui_toggle()
          _gitui:toggle()
        end
      '';

    opts =
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
        undodir = ["${config.xdg.stateHome}/nvim/.undo//"];
        undofile = true;
        wrap = false;
      }
      // (
        if pkgs.stdenv.isDarwin
        then {guifont = "FiraCode Nerd Font:h13";}
        else {guifont = "FiraCode Nerd Font:h10";}
      );

    globals = {
      mapleader = " ";
      neovide_hide_mouse_when_typing = true;
      neovide_unlink_border_highlights = true;
    };

    colorschemes.gruvbox.enable = true;
  };
}
