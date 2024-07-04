{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}:
let
  qml-formatter = pkgs.callPackage ./packages/qml-formatter;
in
{
  imports = [ nixvim.homeManagerModules.nixvim ];

  nix.settings.use-xdg-base-directories = true;

  stylix = {
    targets = {
      nixvim.enable = false;
      rofi.enable = false;
      # hyprpaper.enable = lib.mkForce false;
    };
  };

  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    preferXdgDirectories = true;
    packages = with pkgs; [
      act
      alejandra
      nixfmt-rfc-style
      asciinema
      baobab
      cachix
      cool-retro-term
      comma
      coreutils-full
      curlFull
      dart-sass
      dasel
      dos2unix
      dsq
      duf
      entr
      fastfetch
      fd
      file
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
      meld
      moar
      moreutils
      neovide
      nh
      nix-btm
      nix-diff
      nix-init
      nix-melt
      nix-output-monitor
      nix-tree
      oils-for-unix
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
      # qml-formatter
      quicktype
      recode
      ripgrep
      rippkgs
      rippkgs-index
      scc
      sqlite
      sqlitebrowser
      sshfs
      # swift-format
      sword
      tealdeer
      transmission
      typioca
      util-linux
      visidata
      wget
      wttrbar
      xdg-user-dirs
      xsv
      yt-dlp
      yq
      zstd
    ];

    file = {
      ".config/zls.json".text = builtins.toJSON {
        enable_build_on_save = true;
        build_save_on_step = "check";
      };
      ".config/oils/oshrc".text = # bash
        ''
          if [[ $TERM != "dumb" ]]; then
           eval "$(starship init bash)"
          fi
          eval $(mcfly init bash)
          # eval $(direnv hook bash)
          set -o vi
        '';
    };
  };

  programs = {

    alacritty = import ./users/zcoyle/by-app/alacritty.nix { inherit pkgs lib; };

    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
    };

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
      stdlib = # sh
        ''
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

    firefox = import ./users/zcoyle/by-app/firefox.nix { inherit pkgs; };

    fish.enable = true;

    git = {
      enable = true;
      package = pkgs.gitSVN;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      # FIXME: currently broken on darwin
      difftastic.enable = pkgs.stdenv.isLinux;
      lfs.enable = true;
      extraConfig = {
        push.autoSetupRemote = true;
      };
    };

    gitui = {
      enable = true;
      keyConfig = builtins.readFile ./users/zcoyle/dots/gitui_key_config.ron;
    };

    lazygit.enable = true;

    lf = {
      enable = true;
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

    nixvim = import ./users/zcoyle/by-app/neovim { inherit pkgs lib config; };

    starship =
      let
        nerdfontPreset = pkgs.runCommand "nerdfont.toml" { } ''
          mkdir $out
          ${lib.getExe pkgs.starship} preset nerd-font-symbols -o $out/nerdfont.toml
        '';
      in
      {
        enable = true;
        enableZshIntegration = true;
        enableFishIntegration = true;
        enableTransience = true;
        settings = { } // (builtins.fromTOML (builtins.readFile "${nerdfontPreset}/nerdfont.toml"));
      };

    tmux = {
      enable = true;
      aggressiveResize = true;
      mouse = true;
      keyMode = "vi";
      prefix = "C-b";
      plugins = with pkgs.tmuxPlugins; [
        { plugin = sensible; }
        { plugin = battery; }
        { plugin = mode-indicator; }
      ];
      extraConfig = # sh
        ''
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

    vscode = import ./users/zcoyle/by-app/vscode.nix { inherit pkgs lib; };

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
      dotDir = ".config/zsh";
      enableCompletion = true;
      autosuggestion.enable = true;
      enableVteIntegration = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      autocd = true;

      oh-my-zsh = {
        enable = true;
        plugins = [ "vi-mode" ];
      };

      history = {
        save = 100000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };

      sessionVariables =
        {
          BROWSER = "firefox";
          EDITOR = "nvim";
          GITGET_ROOT = "~/Developer";
          XCURSOR_SIZE = 24;
        }
        // {
          # xdg-ninja recommendations

          # TODO:
          # GNUPGHOME = "${config.xdg.dataHome}/gnupg";

          _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
          ANDROID_HOME = "${config.xdg.dataHome}/android/sdk";
          ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
          CARGO_HOME = "${config.xdg.dataHome}/cargo";
          DVDCSS_CACHE = "${config.xdg.dataHome}/dvdcss";
          GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
          REDISCLI_HISTFILE = "${config.xdg.dataHome}/redis/rediscli_history";
          VALKEYCLI_HISTFILE = "${config.xdg.dataHome}/valkey/valkeycli_history";
          W3M_DIR = "${config.xdg.dataHome}/w3m";
          XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
        };

      shellAliases =
        {
          cat = "bat";
          gl = "git log --one-line --graph | head -n 50";
          j = "z";
          nix-top = "nix-btm";
          repos = "lsd --tree --depth 3 ~/Developer";
          tree = "lsd --tree";
          vi = "nvim";
          vim = "nvim";
        }
        // {
          # xdg-ninja recommendations

          adb = "HOME=${config.xdg.dataHome}/android adb";
          dosbox = "dosbox -conf ${config.xdg.configHome}/dosbox/dosbox.conf";
          yarn = "yarn --use-yarnrc ${config.xdg.configHome}/yarn/config";
        };
    };

    # FIXME: broken on darwin currently
    mpv.enable = pkgs.stdenv.isLinux;

    zathura.enable = true;
  };

  services = {
    syncthing = {
      enable = true;
      # FIXME: when tray enabled it throws an error message.
      # need to figure out how to pass --wait to the tray program
      # tray.enable = true;
      extraOptions = [ ];
    };
  };
}
