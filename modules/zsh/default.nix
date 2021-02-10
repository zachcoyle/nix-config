{ pkgs, programs, ... }:

{
  programs.dircolors = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    enableNixDirenvIntegration = true;
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
      gruvbox
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
      vim = "nvim";
      yeet =
        "home-manager expire-generations `date --iso-8601`; nix-env -p /nix/var/nix/profiles/system --delete-generations old; nix-collect-garbage -d; nix-store --optimise";
      packageScripts = "jq .scripts package.json";

      imanix = "manix \"\" | grep '^# ' | sed 's/^# \(.*\) (.*/\1/;s/ (.*//;s/^# //' | fzf --preview=\"manix '{}'\" | xargs manix";
      switch-darwin = "darwin-rebuild switch --flake ~/.config/nixpkgs && nix build ~/.config/nixpkgs#darwinHomeConfig && ~/.config/nixpkgs/result/activate";
      switch-home = "nix build ~/.config/nixpkgs#linuxHomeConfig && ~/.config/nixpkgs/result/activate";
      switch-nixos = "sudo nixos-rebuild switch --flake ~/.config/nixpkgs";
    };


    sessionVariables = {
      BROWSER = "firefox developer edition";
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
        source ${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/fast-syntax-highlighting.plugin.zsh

        eval "$(${pkgs.starship}/bin/starship init zsh)"
      '';
    };

  };
}
