{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  stylix = {
    targets.nixvim.enable = false;
  };

  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    packages = with pkgs; [
      act
      alejandra
      asciinema
      cachix
      cool-retro-term
      comma
      coreutils-full
      curlFull
      dasel
      dos2unix
      dsq
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableStoneSense = pkgs.stdenv.isLinux;
        enableDwarfTherapist = pkgs.stdenv.isLinux;
      })
      entr
      fd
      ghq
      gimp
      git-bug
      git-get
      gitnr
      gource
      html2text
      hurl
      jq
      just
      killall
      lsix
      manix
      mdcat
      moar
      moreutils
      neofetch
      neovide
      nix-melt
      nix-output-monitor
      nix-top
      opentofu
      oterm
      pijul
      podman
      podman-compose
      podman-tui
      poetry
      prqlc
      process-compose
      python3
      qemu
      quicktype
      recode
      ripgrep
      scc
      sqlite
      sqlitebrowser
      sshfs
      swift-format
      sword
      tealdeer
      typioca
      util-linux
      visidata
      wget
      wttrbar
      xsv
      youtube-dl
      yq
      zstd
    ];

    file = {
      # INFO: this is just to prevent neovide from writing its own settings file
      ".local/share/neovide/neovide-settings.json".text = builtins.toJSON {};
      ".config/borders/bordersrc".text = ''
        #!/bin/bash

        options=(
            style=round
            width=6.0
            hidpi=on
            active_color=0xffebdbb2
            inactive_color=0xff282828
            background_color=0x302c2e34
            blur_radius=25
        )

        borders "''${options[@]}"
      '';
    };
  };

  programs = {
    alacritty = import ./users/zcoyle/by-app/alacritty.nix {inherit pkgs lib;};

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        # theme = "gruvbox-dark";
      };
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };

    bottom.enable = true;
    btop.enable = true;

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = ''
        layout_poetry() {
          if [[ ! -f pyproject.toml ]]; then
            log_error 'No pyproject.toml found.  Use `poetry new` or `poetry init` to create one first.'
            exit 2
          fi

          local VENV=$(dirname $(poetry run which python))
          export VIRTUAL_ENV=$(echo "$VENV" | rev | cut -d'/' -f2- | rev)
          export POETRY_ACTIVE=1
          PATH_add "$VENV"
        }
      '';
    };

    git = {
      enable = true;
      package = pkgs.gitSVN;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      difftastic.enable = true;
      lfs.enable = true;
    };

    lazygit.enable = true;

    gitui = {
      enable = true;
      keyConfig = builtins.readFile ./users/zcoyle/dots/gitui_key_config.ron;
    };

    lsd = {
      enable = true;
      enableAliases = true;
    };

    mcfly = {
      enable = true;
      fuzzySearchFactor = 3;
      enableZshIntegration = true;
      keyScheme = "vim";
    };

    nixvim = import ./users/zcoyle/by-app/neovim {inherit pkgs config;};

    starship = {
      enable = true;
      enableZshIntegration = true;
      # NOTE: the starship.toml was generated with `starship preset nerd-font-symbols -o ./starship.toml`
      # that ought to be a derivation so that it auto updates
      settings = {} // (builtins.fromTOML (builtins.readFile ./users/zcoyle/dots/starship.toml));
    };

    tmux = {
      enable = true;
      aggressiveResize = true;
      mouse = true;
      keyMode = "vi";
      prefix = "C-b";
      plugins = with pkgs.tmuxPlugins; [
        {plugin = sensible;}
        {plugin = battery;}
        {plugin = mode-indicator;}
      ];
      extraConfig = ''
        # Smart pane switching with awareness of Vim splits.
        # See: https://github.com/christoomey/vim-tmux-navigator
        is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|l?n?vim?x?|fzf)(diff)?$'"
        bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
        bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
        bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
        bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
        tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
        if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
        if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

        bind-key -T copy-mode-vi 'C-h' select-pane -L
        bind-key -T copy-mode-vi 'C-j' select-pane -D
        bind-key -T copy-mode-vi 'C-k' select-pane -U
        bind-key -T copy-mode-vi 'C-l' select-pane -R
        bind-key -T copy-mode-vi 'C-\' select-pane -l
      '';
    };

    vscode = import ./users/zcoyle/by-app/vscode.nix {inherit pkgs;};

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    zellij.enable = true;

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion.enable = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      autocd = true;

      oh-my-zsh = {
        enable = true;
        plugins = [
          "vi-mode"
        ];
      };

      sessionVariables = {
        BROWSER = "firefox";
        EDITOR = "nvim";
        GITGET_ROOT = "~/Developer";
        XCURSOR_SIZE = 24;
      };

      shellAliases = {
        cat = "bat";
        j = "z";
        repos = "lsd --tree --depth 3 ~/Developer";
        tree = "lsd --tree";
        vi = "nvim";
        vim = "nvim";
      };
    };

    mpv.enable = true;
    zathura.enable = true;
  };
}
