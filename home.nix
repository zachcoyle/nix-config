{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./home-linux.nix
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
      comma
      coreutils-full
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
      git-get
      gitnr
      hurl
      jq
      just
      killall
      lsix
      manix
      mdcat
      moreutils
      neovide
      nix-melt
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
      xsv
      yq
      zstd
    ];

    file = {
      # INFO: this is just to prevent neovide from writing its own settings file
      ".local/share/neovide/neovide-settings.json".text = builtins.toJSON {};
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
      keyConfig = builtins.readFile ./dots/gitui_key_config.ron;
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
      settings = {};
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
        # {plugin = gruvbox;}
        {plugin = mode-indicator;}
      ];
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
      enableAutosuggestions = true;
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
        EDITOR = "nvim";
        GITGET_ROOT = "~/Developer";
        XCURSOR_SIZE = 24;
      };

      shellAliases = {
        j = "z";
        vi = "nvim";
        vim = "nvim";
        cat = "bat";
        tree = "lsd --tree";
        repos = "lsd --tree --depth 3 ~/Developer";
      };
    };

    mpv.enable = true;
    zathura.enable = true;
  };
}
