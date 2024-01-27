{
  pkgs,
  lib,
  nixvim,
  nix-doom-emacs,
  config,
  ...
}: {
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "Bibata-Modern-Ice";
    size = 24;
    package = pkgs.bibata-cursors;
  };

  # gtk= {
  #   enable = true;
  #     cursorTheme = {
  #       size = 32;
  #     };
  #   }

  services.avizo.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      exec-once = copyq --start-server
      exec-once = swww init
      bind = SUPER, F, exec, firefox
      bind = SUPER, N, exec, nyxt
      bind = SUPER, A, exec, alacritty
      bind = SUPER, W, killactive
      bind = SUPER, T, togglefloating


      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4

      bind = SUPER, K, exec, kickoff

      bind = , XF86AudioRaiseVolume, exec, volumectl -u up
      bind = , XF86AudioLowerVolume, exec, volumectl -u down
      bind = , XF86AudioMute, exec, volumectl toggle-mute

      bind = , XF86MonBrightnessUp, exec, lightctl up
      bind = , XF86MonBrightnessDown, exec, lightctl down

      bind = , XF86AudioPrev, exec, playerctl previous
      bind = , XF86AudioPlay, exec, playerctl play-pause
      bind = , XF86AudioNext, exec, playerctl next

      bind = , XF86KbdBrightnessUp, exec, brightnessctl -d ":white:kbd_backlight" s 10%+
      bind = , XF86KbdBrightnessDown, exec, brightnessctl -d ":white:kbd_backlight" s 10%-
    '';
    settings = {
      decoration = {
        "col.shadow" = "rgba(00000099)";
        active_opacity = 1.0;
        drop_shadow = true;
        inactive_opacity = 0.8;
        rounding = 10;
        shadow_offset = "0 5";
        dim_inactive = true;
      };
      input = {
        kb_options = "caps:swapescape";
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          tap-to-click = true;
          drag_lock = true;
          tap-and-drag = true;
        };
      };
      "$mod" = "SUPER";
      bindm = [
        "$mod, mouse:272, movewindow"
        "$mod, mouse:273, resizewindow"
        "$mod ALT, mouse:272, resizewindow"
      ];
    };
    xwayland.enable = true;
  };
  programs = {
    waybar = {
      enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [
            "custom/logo"
          ];
          modules-right = [
            "pulseaudio/slider"
            "bluetooth"
            "network"
            "battery"
            "clock"
          ];
          "custom/logo" = {
            format = "launch";
            on-click = "kickoff";
          };
        };
      };
      style = ''
      '';
      systemd.enable = true;
    };
    wlogout.enable = true;

    alacritty = {
      enable = true;
      settings = {
        window = {
          decorations_theme_variant = "Dark";
          blur = true;
          opacity = 0.8;
        };
        font.normal.family = "FiraCode Nerd Font";
        font.size = 10.0;
        keyboard.bindings = lib.optionals (pkgs.system == "x86_64-darwin") [
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

    firefox = {
      enable = pkgs.system == "x86_64-linux";
      #package = pkgs.firefox-bin;
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
        settings = {};
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
    mpv = {
      enable = true;
    };
  };

  imports = [
    nixvim.homeManagerModules.nixvim
    nix-doom-emacs.hmModule
  ];
  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    packages = with pkgs;
      [
        act
        asciinema
        alejandra
        buildah
        cachix
        comma
        coreutils-full
        dasel
        dos2unix
        dsq
        (dwarf-fortress-packages.dwarf-fortress-full.override {
          enableStoneSense = pkgs.system == "x86_64-linux";
          enableDwarfTherapist = pkgs.system == "x86_64-linux";
        })
        fd
        ghq
        git-get
        gitnr
        hurl
        jq
        just
        killall
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
        poetry
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
      ]
      ++ lib.optionals (pkgs.system == "x86_64-linux") [
        # wayland-random-wallpaper
        avizo
        brightnessctl
        copyq
        cosmic-files
        kickoff
        playerctl
        swww
        unzip
      ];
    file = {};
  };
}
