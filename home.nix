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
      buildah
      cachix
      comma
      coreutils-full
      dasel
      (dwarf-fortress-packages.dwarf-fortress-full.override {
        enableStoneSense = false;
        enableDwarfTherapist = false;
      })
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
      podman
      podman-compose
      podman-tui
      poetry
      process-compose
      python3
      qemu
      quicktype
      ripgrep
      scc
      swift-format
      sword
      tealdeer
      yq
    ];
    file = {};
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        decorations_theme_variant = "Dark";
        font.normal.family = "FiraCode Nerd Font";
        font.size = 13.0;
        key_bindings = [
          # TODO: enable when next version releases
          # {
          #   key = "T";
          #   mods = "Command";
          #   action = "CreateNewTab";
          # }
        ];
        import = ["${pkgs.alacritty-theme}/gruvbox_dark.yaml"];
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
    };

    doom-emacs = {
      enable = true;
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
