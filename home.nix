{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}: let
  lf-previewer = pkgs.writeShellApplication {
    name = "lf-previewer";
    runtimeInputs = with pkgs; [bat];
    text = ''
      bat --color=always --theme=gruvbox-dark "$1"
    '';
  };
in {
  imports = [
    nixvim.homeManagerModules.nixvim
    ./users/zcoyle/by-app/alacritty.nix
    ./users/zcoyle/by-app/firefox.nix
    ./users/zcoyle/by-app/neovim
    ./users/zcoyle/by-app/ghostty.nix
  ];

  stylix = {
    targets = {
      nixvim.enable = false;
      rofi.enable = false;
    };
  };

  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    preferXdgDirectories = true;
    packages = with pkgs; [
      act
      alejandra
      asciinema
      atac
      baobab
      cachix
      comma
      cool-retro-term
      coreutils-full
      curlFull
      dart-sass
      dasel
      dos2unix
      dsq
      duf
      entr
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
      lazyjj
      lsix
      manix
      md-tui
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
      opentofu
      oterm
      pijul
      podman
      podman-compose
      podman-tui
      poetry
      portal
      process-compose
      prqlc
      qemu
      quicktype
      recode
      ripgrep
      rippkgs
      scc
      sqlite
      sqlitebrowser
      sshfs
      # swift-format
      sword
      tealdeer
      termshark
      typioca
      util-linux
      wget
      wttrbar
      xdg-user-dirs
      xsv
      yq
      yt-dlp
      yubikey-manager
      zstd
    ];

    file = {
      ".config/zls.json".text = builtins.toJSON {
        enable_build_on_save = true;
        build_save_on_step = "check";
      };
    };

    shellAliases = {
      cat = "bat";
      gl = "git log --one-line --graph | head -n 50";
      j = "z";
      nix-top = "nix-btm";
      repos = "lsd --tree --depth 3 ~/Developer";
      tree = "lsd --tree";
      vi = "nvim";
      vim = "nvim";

      # xdg-ninja recommendations:
      adb = "HOME=${config.xdg.dataHome}/android adb";
      dosbox = "dosbox -conf ${config.xdg.configHome}/dosbox/dosbox.conf";
      yarn = "yarn --use-yarnrc ${config.xdg.configHome}/yarn/config";
    };

    sessionVariables = {
      BROWSER = "firefox";
      EDITOR = "nvim";
      GITGET_ROOT = "~/Developer";
      XCURSOR_SIZE = 24;

      # xdg-ninja recommendations:
      # TODO:
      # GNUPGHOME = "${config.xdg.dataHome}/gnupg";

      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      ANDROID_HOME = "${config.xdg.dataHome}/android/sdk";
      ANDROID_USER_HOME = "${config.xdg.dataHome}/android";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      DVDCSS_CACHE = "${config.xdg.dataHome}/dvdcss";
      # GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      REDISCLI_HISTFILE = "${config.xdg.dataHome}/redis/rediscli_history";
      VALKEYCLI_HISTFILE = "${config.xdg.dataHome}/valkey/valkeycli_history";
      W3M_DIR = "${config.xdg.dataHome}/w3m";
      XCOMPOSECACHE = "${config.xdg.cacheHome}/X11/xcompose";
    };
  };

  programs = {
    atuin = {
      enable = true;
      settings = {
        auto_sync = true;
        sync_frequency = "5m";
        sync_address = "http://nixos-desktop:8888";
        search_mode = "fuzzy";
        keymap_mode = "vim-normal";
      };
    };

    bash = {
      enable = true;
      historyFile = "${config.xdg.stateHome}/bash/history";
    };

    bat = {
      enable = true;
      config.pager = "less -FR";

      extraPackages = with pkgs.bat-extras; [
        # batdiff
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
      stdlib =
        # sh
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

    git = {
      enable = true;
      package = pkgs.gitSVN;
      userEmail = "zach.coyle@gmail.com";
      userName = "Zach Coyle";
      # FIXME: currently broken on darwin
      difftastic.enable = pkgs.stdenv.isLinux;
      lfs.enable = true;
      extraConfig.push.autoSetupRemote = true;
    };

    gitui = {
      enable = true;
      keyConfig = builtins.readFile ./users/zcoyle/dots/gitui_key_config.ron;
    };

    jujutsu = {
      enable = true;
      ediff = false;
      settings = {
        user = {
          name = "Zach Coyle";
          email = "zach.coyle@gmail.com";
        };
        ui.default-command = ["log"];
      };
    };

    lazygit.enable = true;

    lf = {
      enable = true;
      cmdKeybindings = {};
      commands = {};
      keybindings = {};
      previewer = {
        keybinding = "i";
        source = ''${lf-previewer}/bin/lf-previewer "$@"'';
      };
      settings = {
        number = true;
        ratios = [
          1
          1
          2
        ];
        tabstop = 4;
      };
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

    # password-store = {
    #   package = pkgs.pass.withExtensions (
    #     exts: with exts; [
    #       pass-otp
    #       pass-audit
    #       pass-update
    #       # pass-import
    #       pass-checkup
    #       pass-genphrase
    #     ]
    #   );
    #   enable = true;
    #   settings = {
    #     # FIXME:
    #     PASSWORD_STORE_DIR = "/home/zcoyle/Passwords";
    #   };
    # };

    starship = let
      nerdfontPreset = pkgs.runCommand "nerdfont.toml" {} ''
        mkdir $out
        ${lib.getExe pkgs.starship} preset nerd-font-symbols -o $out/nerdfont.toml
      '';
    in {
      enable = true;
      enableZshIntegration = true;
      settings = {} // (builtins.fromTOML (builtins.readFile "${nerdfontPreset}/nerdfont.toml"));
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
      extraConfig =
        # sh
        ''
          # Smart pane switching with awareness of Vim splits.
          # INFO: See: https://github.com/christoomey/vim-tmux-navigator
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

          # INFO: colors fix https://stackoverflow.com/a/77871533
          set -g default-terminal "alacritty"
          set-option -sa terminal-overrides ",alacritty*:Tc"
        '';
    };

    vscode = {
      enable = true;
      package = pkgs.vscodium;
    };

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
        plugins = ["vi-mode"];
      };

      history = {
        save = 100000;
        path = "${config.xdg.dataHome}/zsh/zsh_history";
      };
    };

    # FIXME: broken on darwin currently
    mpv.enable = pkgs.stdenv.isLinux;

    zathura = {
      enable = true;
      options = {
        recolor = true;
        recolor-keephue = true;
      };
    };
  };

  services = {
    syncthing = {
      enable = true;
      # FIXME: when tray enabled it throws an error message.
      # need to figure out how to pass --wait to the tray program
      # tray.enable = true;
      extraOptions = [];
    };
  };
}
