{
  pkgs,
  lib,
  alacritty-theme,
  nixvim,
  nix-doom-emacs,
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
      jq
      just
      coreutils-full
      moreutils
      neovide
      nodejs_20
      nodePackages_latest.pnpm
      podman
      podman-tui
      poetry
      python3
      qemu
      swift-format
      cachix
      # TODO: revisit this, only really need xdebug at the moment
      (php.withExtensions ({
        enabled,
        all,
      }:
        enabled ++ [all.xdebug]))
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

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    doom-emacs = {
      enable = true;
      doomPrivateDir = ./doom.d; # Directory containing your config.el, init.el and packages.el files
    };

    git = {
      enable = true;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      delta.enable = true;
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

    nixvim = import ./nixvim.nix {inherit pkgs lib;};

    ripgrep.enable = true;

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
        # TODO: check to see if nixvim provides this
        vi = "nvim";
        vim = "nvim";
        cat = "bat";
      };
    };
  };
}
