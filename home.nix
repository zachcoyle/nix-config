{
  config,
  pkgs,
  alacritty-theme,
  nixvim,
  ...
}: {
  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  home = {
    username = "zcoyle";
    stateVersion = "23.05";
    packages = with pkgs; [
      python3
      poetry
      nodejs_20
      nodePackages_latest.pnpm
      podman
      podman-tui
      qemu
      swift-format
      alejandra
      jq
      ripgrep
      neovide
      moreutils
    ];
  };

  programs = {
    alacritty = {
      enable = true;
      settings = {
        decorations_theme_variant = "Dark";
        font.normal.family = "FiraCode Nerd Font";
        font.size = 12.0;
        key_bindings = [
          # TODO: enable when next version releases
          # {
          #   key = "T";
          #   mods = "Command";
          #   action = "CreateNewTab";
          # }
        ];
        import = ["${alacritty-theme}/themes/gruvbox_dark.yaml"];
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

    dircolors = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      delta.enable = true;
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

    nixvim = import ./nixvim.nix {inherit (pkgs) vimPlugins;};

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

      shellAliases = {
        j = "z";
        # TODO: check to see if nixvim provides this
        vi = "nvim";
        vim = "nvim";
        cat = "bat";
      };
    };
  };
}
