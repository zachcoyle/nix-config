{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}: let
  neovide_settings = builtins.toJSON {
    frame = "none";
    title-hidden = true;
  };
in {
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
      baobab
      cachix
      cool-retro-term
      comma
      coreutils-full
      curlFull
      dasel
      dos2unix
      dsq
      duf
      entr
      fastfetch
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
      neovide
      nh
      nix-melt
      nix-output-monitor
      nix-top
      opentofu
      # oterm
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
      rippkgs
      rippkgs-index
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
      yt-dlp
      yq
      zstd
    ];

    file =
      if pkgs.stdenv.isDarwin
      then {
        "Library/Application\ Support/neovide/neovide-settings.json".text = lib.mkIf pkgs.stdenv.isDarwin neovide_settings;
        ".config/borders/bordersrc".executable = true;
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
      }
      else {
        ".local/share/neovide/neovide-settings.json".text = neovide_settings;
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

    firefox = let
      darwin-package = pkgs.firefox-bin;
      linux-package =
        pkgs.wrapFirefox pkgs.firefox-bin-unwrapped
        {
          extraPolicies = {
            DisableFirefoxStudies = true;
            DisablePocket = true;
            NoDefaultBookmarks = true;
            FirefoxHome = {
              Search = true;
              Pocket = false;
              TopSites = false;
              Highlights = false;
            };
            UserMessaging = {
              ExtensionRecommendations = false;
              SkipOnboarding = true;
            };
          };
        };
    in {
      enable = true;
      package =
        if pkgs.stdenv.isDarwin
        then darwin-package
        else linux-package;

      profiles.zcoyle = {
        id = 0;
        name = "zcoyle";
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          dearrow
          firenvim
          nighttab
          react-devtools
          reddit-enhancement-suite
          reduxdevtools
          stylus
          ublock-origin
          vimium
          vue-js-devtools
          wayback-machine
        ];

        search = {
          force = true;
          default = "Brave";
          engines = {
            Brave = {
              urls = [{template = "https://search.brave.com/search?q={searchTerms}";}];
              iconUpdateURL = "https://cdn.search.brave.com/serp/v2/_app/immutable/assets/brave-search-icon.CsIFM2aN.svg";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@b"];
            };
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@np"];
            };
            "NixOS Options" = {
              urls = [
                {
                  template = "https://search.nixos.org/options";
                  params = [
                    {
                      name = "channel";
                      value = "unstable";
                    }
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = ["@no"];
            };
            "NixOS Wiki" = {
              urls = [{template = "https://nixos.wiki/index.php?search={searchTerms}";}];
              iconUpdateURL = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@nw"];
            };
            "Ollama" = {
              urls = [{template = "https://ollama.com/search?q={searchTerms}";}];
              iconUpdateURL = "https://ollama.com/public/icon-32x32.png";
              updateInterval = 24 * 60 * 60 * 1000;
              definedAliases = ["@ll"];
            };
            "Wikipedia (en)".metaData.alias = "@wiki";
            "Google".metaData.hidden = true;
            "Amazon.com".metaData.hidden = true;
            "Bing".metaData.hidden = true;
            "eBay".metaData.hidden = true;
          };
        };

        settings = {
          "general.smoothScroll" = true;
          # disable alt key bringing up window menu
          "ui.key.menuAccessKeyFocuses" = false;
        };

        extraConfig = ''
          user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
          user_pref("full-screen-api.ignore-widgets", true);
          user_pref("media.ffmpeg.vaapi.enabled", true);
          user_pref("media.rdd-vpx.enabled", true);
          user_pref("apz.overscroll.enabled", true);
          user_pref("browser.shell.checkDefaultBrowser", false);
        '';

        userChrome = ''
          .titlebar-buttonbox-container {
            display: none !important;
          }
          statuspanel[type="overLink"] .statuspanel-label {
            display: none !important;
          }
          #appcontent statuspanel {
            display: none;
          }
          #statuspanel-label {
            display: none;
          }
        '';

        userContent = ''
        '';
      };
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

    starship = let
      nerdfontPreset = pkgs.runCommand "nerdfont.toml" {} ''
        mkdir $out
        ${pkgs.starship}/bin/starship preset nerd-font-symbols -o $out/nerdfont.toml
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
        gl = "git log --one-line --graph | head -n 50";
      };
    };

    mpv.enable = true;
    zathura.enable = true;
  };

  services = {
    syncthing = {
      enable = true;
      tray.enable = true;
      extraOptions = [];
    };
  };
}
