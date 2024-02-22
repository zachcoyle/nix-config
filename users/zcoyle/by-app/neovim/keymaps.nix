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
    action = ":noh<cr>";
    options = {
      silent = true;
      desc = "Clear Highlights";
    };
  }
  {
    key = "<leader>ca";
    action = "vim.lsp.buf.code_action";
    options = {
      silent = true;
      desc = "LSP Code Actions";
    };
    lua = true;
  }
  {
    key = "<leader>rn";
    action = "vim.lsp.buf.rename";
    options = {
      silent = true;
      desc = "LSP Rename";
    };
    lua = true;
  }
  {
    key = "zR";
    action = "require('ufo').openAllFolds";
    options = {
      silent = true;
      desc = "UFO Open All Folds";
    };
    lua = true;
  }
  {
    key = "zM";
    action = "require('ufo').closeAllFolds";
    options = {
      silent = true;
      desc = "UFO Close All Folds";
    };
    lua = true;
  }
  {
    key = "zr";
    action = "require('ufo').openFoldsExceptKinds";
    options = {
      silent = true;
      desc = "UFO Open Folds Except Kinds";
    };
    lua = true;
  }
  {
    key = "zm";
    action = "require('ufo').closeFoldsWith";
    options = {
      silent = true;
      desc = "Close Folds With";
    };
    lua = true;
  }
  {
    key = "<leader>dc";
    action = ":DapContinue<cr>";
    options = {
      silent = true;
      desc = "DAP Continue";
    };
  }
  {
    key = "<leader>dt";
    action = "function() if vim.bo.filetype == 'java' then vim.cmd('JdtUpdateDebugConfig') end; require('dapui').toggle() end";
    options = {
      silent = true;
      desc = "DAPUI Toggle";
    };
    lua = true;
  }
  {
    key = "<leader>th";
    action = ":Telescope harpoon marks<cr>";
    options = {
      silent = true;
      desc = "Telescope Harpoon Marks";
    };
  }
  {
    key = "<leader>tr";
    action = "require('refactoring').select_refactor";
    options = {
      silent = true;
      desc = "Telescope Refactor";
    };
    lua = true;
  }
  {
    key = "<leader>tu";
    action = "require('telescope').extensions.undo.undo";
    options = {
      silent = true;
      desc = "Telescope Undo";
    };
    lua = true;
  }
  {
    key = "<leader>tf";
    action = "require('telescope').extensions.file_browser.file_browser";
    options = {
      silent = true;
      desc = "Telecope File Browser";
    };
    lua = true;
  }
  {
    action = "require('just').just";
    key = "<leader>tj";
    lua = true;
    options = {
      silent = true;
      desc = "Telescope Just";
    };
  }
  {
    key = "<leader>tl";
    action = "require('trouble.providers.telescope').open_with_trouble";
    lua = true;
    options = {
      silent = true;
      desc = "Telescope Trouble";
    };
  }
  {
    key = "<leader>td";
    action = ":TodoTelescope<cr>";
    options = {
      silent = true;
      desc = "Telescope Todos";
    };
  }
  {
    key = "<leader>tp";
    action = ":Telescope projects<cr>";
    options = {
      silent = true;
      desc = "Telescope Projects";
    };
  }
  {
    key = "]t";
    action = "require('todo-comments').jump_next";
    options = {
      silent = true;
      desc = "Jump to Next TODO";
    };
    mode = "n";
    lua = true;
  }
  {
    key = "[t";
    action = "require('todo-comments').jump_prev";
    options = {
      silent = true;
      desc = "Jump to Previous TODO";
    };
    mode = "n";
    lua = true;
  }
  {
    key = "K";
    action = "function() vim.cmd[[ Lspsaga hover_doc ]] end";
    options = {
      silent = false;
      desc = "LSP Hover";
    };
    lua = true;
  }
  {
    key = "<leader>di";
    action = "require('dap.ui.widgets').hover";
    options = {
      silent = true;
      desc = "DAPUI Hover/Inspect";
    };
    lua = true;
  }
  {
    key = ";";
    action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_next";
    options = {
      silent = true;
      desc = "Repeat Last Move Next";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = ",";
    action = "require('nvim-treesitter.textobjects.repeatable_move').repeat_last_move_previous";
    options = {
      silent = true;
      desc = "Repeat Last Move Previous";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = "f";
    action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_f";
    options = {
      silent = true;
      desc = "fancy f";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = "F";
    action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_F";
    options = {
      silent = true;
      desc = "fancy F";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = "t";
    action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_t";
    options = {
      silent = true;
      desc = "fancy t";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = "T";
    action = "require('nvim-treesitter.textobjects.repeatable_move').builtin_T";
    options = {
      silent = true;
      desc = "fancy T";
    };
    lua = true;
    mode = ["n" "x" "o"];
  }
  {
    key = "<leader>go";
    action = "require('neogit').open";
    options = {
      silent = true;
      desc = "Open Neogit";
    };
    lua = true;
    mode = ["n"];
  }
  {
    key = "<leader>nb";
    action = ":Navbuddy<cr>";
    options = {
      silent = true;
      desc = "Open Navbuddy";
    };
  }
  {
    key = "<leader>oo";
    action = ":<c-u>lua require('ollama').prompt()<cr>";
    options = {
      desc = "ollama prompt";
    };
    mode = ["n" "v"];
  }
  {
    key = "<leader>oG";
    action = ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>";
    options = {
      desc = "ollama Generate Code";
    };
    mode = ["n" "v"];
  }
]
