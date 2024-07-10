[
  {
    key = "<c-h>";
    action = "<c-w>h>";
    options = {
      silent = true;
      desc = "West";
    };
  }
  {
    key = "<c-j>";
    action = "<c-w>j";
    options = {
      silent = true;
      desc = "South";
    };
  }
  {
    key = "<c-k>";
    action = "<c-w>k";
    options = {
      silent = true;
      desc = "North";
    };
  }
  {
    key = "<c-l>";
    action = "<c-w>l";
    options = {
      silent = true;
      desc = "East";
    };
  }
  {
    key = "<leader>ch";
    action = # vim
      ":noh<cr>";
    options = {
      silent = true;
      desc = "Clear Highlights";
    };
  }
  {
    key = "<leader>ca";
    action.__raw = "vim.lsp.buf.code_action";
    options = {
      silent = true;
      desc = "LSP Code Actions";
    };
  }
  {
    key = "<leader>rn";
    action.__raw = "vim.lsp.buf.rename";
    options = {
      silent = true;
      desc = "LSP Rename";
    };
  }
  {
    key = "zR";
    action.__raw = "require('ufo').openAllFolds";
    options = {
      silent = true;
      desc = "UFO Open All Folds";
    };
  }
  {
    key = "zM";
    action.__raw = "require('ufo').closeAllFolds";
    options = {
      silent = true;
      desc = "UFO Close All Folds";
    };
  }
  {
    key = "zr";
    action.__raw = "require('ufo').openFoldsExceptKinds";
    options = {
      silent = true;
      desc = "UFO Open Folds Except Kinds";
    };
  }
  {
    key = "zm";
    action.__raw = "require('ufo').closeFoldsWith";
    options = {
      silent = true;
      desc = "Close Folds With";
    };
  }
  {
    key = "<leader>dc";
    action = # vim
      ":DapContinue<cr>";
    options = {
      silent = true;
      desc = "DAP Continue";
    };
  }
  {
    key = "<leader>dt";
    action.__raw = "function() if vim.bo.filetype == 'java' then vim.cmd('JdtUpdateDebugConfig') end; require('dapui').toggle() end";
    options = {
      silent = true;
      desc = "DAPUI Toggle";
    };
  }
  {
    key = "<leader>th";
    action = # vim
      ":Telescope harpoon marks<cr>";
    options = {
      silent = true;
      desc = "Telescope Harpoon Marks";
    };
  }
  {
    key = "<leader>tr";
    action.__raw = "require('refactoring').select_refactor";
    options = {
      silent = true;
      desc = "Telescope Refactor";
    };
  }
  {
    key = "<leader>tu";
    action.__raw = "require('telescope').extensions.undo.undo";
    options = {
      silent = true;
      desc = "Telescope Undo";
    };
  }
  {
    key = "<leader>tf";
    action.__raw = "require('telescope').extensions.file_browser.file_browser";
    options = {
      silent = true;
      desc = "Telecope File Browser";
    };
  }
  {
    action.__raw = "require('just').just";
    key = "<leader>tj";
    options = {
      silent = true;
      desc = "Telescope Just";
    };
  }
  {
    key = "<leader>tl";
    action.__raw = "require('trouble.sources.telescope').open";
    options = {
      silent = true;
      desc = "Telescope Trouble";
    };
  }
  {
    key = "<leader>td";
    action = # vim
      ":TodoTelescope<cr>";
    options = {
      silent = true;
      desc = "Telescope Todos";
    };
  }
  {
    key = "<leader>tp";
    action = # vim
      ":Telescope projects<cr>";
    options = {
      silent = true;
      desc = "Telescope Projects";
    };
  }
  {
    key = "]t";
    action.__raw = "require('todo-comments').jump_next";
    options = {
      silent = true;
      desc = "Jump to Next TODO";
    };
    mode = "n";
  }
  {
    key = "[t";
    action.__raw = "require('todo-comments').jump_prev";
    options = {
      silent = true;
      desc = "Jump to Previous TODO";
    };
    mode = "n";
  }
  {
    key = "K";
    action.__raw = "function() vim.cmd[[ Lspsaga hover_doc ]] end";
    options = {
      silent = false;
      desc = "LSP Hover";
    };
  }
  {
    key = "<leader>di";
    action.__raw = "require('dap.ui.widgets').hover";
    options = {
      silent = true;
      desc = "DAPUI Hover/Inspect";
    };
  }
  {
    key = ";";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next";
    options = {
      silent = true;
      desc = "Repeat Last Move Next";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = ",";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous";
    options = {
      silent = true;
      desc = "Repeat Last Move Previous";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = "f";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').builtin_f";
    options = {
      silent = true;
      desc = "fancy f";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = "F";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').builtin_F";
    options = {
      silent = true;
      desc = "fancy F";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = "t";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').builtin_t";
    options = {
      silent = true;
      desc = "fancy t";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = "T";
    action.__raw = "require('nvim-treesitter.textobjects.repeatable_move').builtin_T";
    options = {
      silent = true;
      desc = "fancy T";
    };
    mode = [
      "n"
      "x"
      "o"
    ];
  }
  {
    key = "<leader>go";
    action.__raw = "require('neogit').open";
    options = {
      silent = true;
      desc = "Open Neogit";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>nb";
    action = # vim
      ":Navbuddy<cr>";
    options = {
      silent = true;
      desc = "Open Navbuddy";
    };
  }
  {
    key = "<leader>ll";
    action = # vim
      ":<c-u>lua require('ollama').prompt()<cr>";
    options = {
      desc = "ollama prompt";
    };
    mode = [
      "n"
      "v"
    ];
  }
  {
    key = "<leader>lG";
    action = # vim
      ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>";
    options = {
      desc = "ollama Generate Code";
    };
    mode = [
      "n"
      "v"
    ];
  }
  {
    key = "<c-g>";
    action.__raw = "_gitui_toggle";
    options = {
      silent = true;
      desc = "Open GitUI";
    };
    mode = [
      "n"
      "t"
    ];
  }
  {
    key = "s";
    action.__raw = ''require("flash").remote'';
  }
  #  TODO: improve the otter bindings later by getting 
  #  all the current injections of the current
  #  buffer from the data returned by:
  #  vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()] 
  {
    key = "<leader>ob";
    action.__raw = ''function() require("otter").activate({ "bash" }) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Bash";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>oc";
    action.__raw = ''function() require("otter").activate({ "css" }) end'';
    options = {
      silent = true;
      desc = "Otter: Activate CSS";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>oh";
    action.__raw = ''function() require("otter").activate({ "haskell" }, true, true, nil) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Haskell";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>oj";
    action.__raw = ''function() require("otter").activate({ "javascript"}, true, true, nil) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Javascript";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>ol";
    action.__raw = ''function() require("otter").activate({ "lua" }, true, true, nil) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Lua";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>op";
    action.__raw = ''function() require("otter").activate({ "python" }, true, true, nil) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Python";
    };
    mode = [ "n" ];
  }
  {
    key = "<leader>or";
    action.__raw = ''function() require("otter").activate({ "rust" }, true, true, nil) end'';
    options = {
      silent = true;
      desc = "Otter: Activate Rust";
    };
    mode = [ "n" ];
  }
]
