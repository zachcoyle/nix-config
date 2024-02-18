{
  pkgs,
  config,
}: {
  enable = true;

  package = pkgs.neovim;

  enableMan = false;

  luaLoader.enable = true;

  editorconfig.enable = true;

  extraPackages = with pkgs;
  # utility
    [
      fd
      lazygit
      ripgrep
      tabnine
      rust-analyzer
    ]
    # dap
    ++ [
      rustc
      pkgs.vscode-extensions.vadimcn.vscode-lldb.adapter
      cargo
      lldb
      (php.withExtensions ({
        enabled,
        all,
      }:
        enabled ++ [all.xdebug]))
    ]
    # formatters
    ++ [
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

  extraPlugins = with (pkgs.vimPlugins // pkgs.vimExtraPlugins); [
    neorepl-nvim
    nvim-autopairs
    sg-nvim
    statuscol-nvim
    telescope_just
    tint-nvim
    yuck-vim
  ];

  extraConfigLua = ''
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

    -- make telescope projects appear when started without args
    vim.api.nvim_create_autocmd('UIEnter', {
      group = vim.api.nvim_create_augroup('Dashboard', { clear = true }),
      callback = function()
        if
          vim.fn.argc() == 0
          and vim.api.nvim_buf_line_count(0) == 1
          and vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == ""
        then
          require("telescope").extensions.projects.projects{}
        end
      end,
    })
  '';

  options = {
    mouse = "a";
    mousemoveevent = true;
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
    scrolloff = 8;
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
    neovide_hide_mouse_when_typing = true;
  };

  keymaps = import ./keymaps.nix;

  colorschemes = {
    gruvbox = {
      enable = true;
    };
  };

  plugins = import ./plugins.nix {inherit pkgs config;};
}
