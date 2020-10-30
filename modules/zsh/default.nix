{ pkgs, programs, ... }:

{
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    stdlib = builtins.readFile ./config/direnvrc;
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.tmux = {
    enable = true;
    aggressiveResize = false; # disabled for iterm
    keyMode = "vi";
    newSession = true;
    tmuxp.enable = true;
    plugins = with pkgs.tmuxPlugins; [
      battery
      nord
      online-status
      prefix-highlight
      sensible
      vim-tmux-navigator
    ];
    extraConfig = builtins.readFile ./config/tmux.conf;
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    defaultKeymap = "viins";
    autocd = true;
    shellAliases = {
      cat = "bat --theme TwoDark --paging never";
      ls = "lsd -F";
      rm = "safe-rm -iv";
      yeet =
        "home-manager expire-generations `date --iso-8601`; nix-env -p /nix/var/nix/profiles/system --delete-generations old; nix-collect-garbage -d; nix-store --optimise";
      packageScripts = "jq .scripts package.json";
    };
    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "vim";
      FASTLANE_OPT_OUT_USAGE = "YES";
      NIX_IGNORE_SYMLINK_STORE = "1";
      DOTNET_CLI_TELEMETRY_OPTOUT = "true";
      REACT_TERMINAL = "iTerm";
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "adb"
        "bundler"
        "cabal"
        "cargo"
        "catimg"
        "celery"
        "colored-man-pages"
        "docker"
        "docker-compose"
        "docker-machine"
        "fzf"
        "git"
        "git-flow"
        "gnu-utils"
        "gradle"
        "iterm2"
        "lein"
        "npm"
        "redis-cli"
        "rust"
        "rustup"
        "sudo"
        "terraform"
        "tig"
        "vi-mode"
        "xcode"
        "yarn"
      ];
      extraConfig = ''
        source ${pkgs.jump}/share/zsh/site-functions/_jump
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh
        ${builtins.readFile ./config/p10k.zsh}
      '';
    };

  };
}
