{
  config,
  pkgs,
  alacritty-theme,
  nixvim,
  ...
}: {
  home.username = "zcoyle";

  home.stateVersion = "23.05";

  imports = [
    nixvim.homeManagerModules.nixvim
  ];

  home.packages = with pkgs; [
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
  ];

  programs.alacritty = {
    enable = true;
    settings = {
      decorations_theme_variant = "Dark";
      font.normal.family = "FiraCode Nerd Font";
      font.size = 12.0;
      import = ["${alacritty-theme}/themes/gruvbox_dark.yaml"];
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  programs.mcfly = {
    enable = true;
    fuzzySearchFactor = 3;
    enableZshIntegration = true;
    keyScheme = "vim";
  };

  programs.nixvim = import ./nvim.nix {inherit (pkgs) vimPlugins;};

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    defaultKeymap = "viins";
    autocd = true;

    oh-my-zsh = {
      enable = true;
      plugins = [];
    };

    shellAliases = {
      j = "z";
      # TODO: check to see if nixvim provides this
      vi = "nvim";
      vim = "nvim";
    };
  };
}
