{pkgs}: {
  enable = true;

  package = pkgs.vscodium;
  enableUpdateCheck = false;
  enableExtensionUpdateCheck = false;

  # FIXME:
  # https://github.com/nix-community/nix-vscode-extensions/issues/57
  #
  # extensions = with pkgs.open-vsx; [
  #   bbenoist.nix
  #   charliermarsh.ruff
  #   codezombiech.gitignore
  #   dbaeumer.vscode-eslint
  #   eamodio.gitlens
  #   editorconfig.editorconfig
  #   esbenp.prettier-vscode
  #   evgeniypeshkov.syntax-highlighter
  #   gruntfuggly.todo-tree
  #   # jdinhlife.gruvbox
  #   kamadorueda.alejandra
  #   kokakiwi.vscode-just
  #   mkhl.direnv
  #   ms-python.python
  #   oderwat.indent-rainbow
  #   rust-lang.rust-analyzer
  #   vadimcn.vscode-lldb
  #   vknabel.vscode-apple-swift-format
  #   vscodevim.vim
  #   vue.volar
  #   xdebug.php-debug
  # ];

  userSettings = {
    "[javascript]" = {
      editor.defaultFormatter = "esbenp.prettier-vscode";
    };
    "[vue]" = {
      editor.defaultFormatter = "esbenp.prettier-vscode";
    };
    "[jsonc]" = {
      editor.defaultFormatter = "esbenp.prettier-vscode";
    };
    git = {
      autofetch = true;
      confirmSync = false;
    };
    diffEditor.ignoreTrimWhitespace = false;
    lldb = {
      # FIXME: hardcoded path
      library = "/Applications/Xcode.app/Contents/SharedFrameworks/LLDB.framework/Versions/A/LLDB";
      launch.expressions = "native";
    };
    apple-swift-format.path = ["swift-format"];
    update = {
      mode = "none";
    };
    editor = {
      cursorStyle = "block";
      fontFamily = "FiraCode Nerd Font";
      fontLigatures = true;
      formatOnSave = true;
      guides.bracketPairs = true;
      lineNumbers = "relative";
      tabSize = 2;
    };
    telemetry = {
      enableCrashReporter = false;
      enableTelemetry = false;
    };
    vscode-neovim.neovimPath = "${pkgs.neovim}/bin/nvim";
    workbench = {
      editor.empty.hint = "hidden";
      # colorTheme = "Gruvbox Dark Hard";
      startupEditor = "none";
    };
  };
}
