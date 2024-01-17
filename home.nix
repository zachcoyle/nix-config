{
  pkgs,
  nixvim,
  nix-doom-emacs,
  config,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
    nix-doom-emacs.hmModule
  ];
  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    packages = with pkgs; [
      act
      asciinema
      alejandra
      # buildah
      cachix
      comma
      coreutils-full
      dasel
      dos2unix
      dsq
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableStoneSense = false;
        enableDwarfTherapist = false;
      })
      fd
      ghq
      git-get
      gitnr
      hurl
      jq
      just
      manix
      mdcat
      moreutils
      neovide
      nix-melt
      nix-top
      opentofu
      pijul
      podman
      podman-compose
      podman-tui
      # poetry
      process-compose
      python3
      qemu
      quicktype
      ripgrep
      scc
      sqlite
      swift-format
      sword
      tealdeer
      util-linux
      visidata
      wget
      xsv
      yq
    ];
    file = {};
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations_theme_variant = "Dark";
          blur = true;
          opacity = 0.8;
        };
        font.normal.family = "FiraCode Nerd Font";
        font.size = 13.0;
        keyboard.bindings = [
          {
            key = "T";
            mods = "Command";
            action = "CreateNewTab";
          }
        ];
        import = ["${pkgs.alacritty-theme}/gruvbox_dark.toml"];
      };
    };

    bat = {
      enable = true;
      config = {
        pager = "less -FR";
        theme = "gruvbox-dark";
      };
      extraPackages = with pkgs.bat-extras; [batdiff batman batgrep batwatch];
    };

    bottom.enable = true;

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

    doom-emacs = {
      enable = false;
      doomPrivateDir = ./dots/doom.d;
    };

    # firefox = {
    #   enable = true;
    #   package = pkgs.firefox-bin;
    #   profiles.zcoyle = {
    #     extensions = with pkgs.nur.repos.rycee.firefox-addons; [
    #       firenvim
    #       gruvbox-dark-theme
    #       react-devtools
    #       reduxdevtools
    #       ublock-origin
    #       vue-js-devtools
    #       wayback-machine
    #     ];
    #     settings = {};
    #   };
    # };

    git = {
      enable = true;
      package = pkgs.gitSVN;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      difftastic.enable = true;
      lfs.enable = true;
    };

    lazygit.enable = true;

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

    nixvim = import ./nixvim.nix {inherit pkgs config;};

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
        {plugin = gruvbox;}
        {plugin = mode-indicator;}
      ];
    };

    vscode = import ./vscode.nix {inherit pkgs;};

    zellij = {
      enable = true;
      settings = {
        theme = "gruvbox-dark";
      };
    };

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
  };
}
