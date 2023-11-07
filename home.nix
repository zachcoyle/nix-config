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
    stateVersion = "23.05";
    packages = with pkgs; [
      alejandra
      cachix
      coreutils-full
      jq
      just
      moreutils
      neovide
      nodejs_20
      nodePackages_latest.pnpm
      podman
      podman-compose
      podman-tui
      buildah
      poetry
      python3
      qemu
      ripgrep
      swift-format
      nix-melt
      nix-top
      manix
    ];
    file = {
      # TODO: VSCode stuff
    };
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

    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      profiles.zcoyle = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          firenvim
          gruvbox-dark-theme
          react-devtools
          reduxdevtools
          ublock-origin
          vue-js-devtools
          wayback-machine
        ];
      };
      settings = {};
    };

    git = {
      enable = true;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      delta.enable = true;
      # difftastic.enable = true;
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
      };

      shellAliases = {
        j = "z";
        vi = "nvim";
        vim = "nvim";
        cat = "bat";
        tree = "lsd --tree";
      };
    };
  };
}
