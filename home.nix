{
  pkgs,
  lib,
  nixvim,
  config,
  ...
}: {
  qt = lib.mkIf (pkgs.system == "x86_64-linux") {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  gtk = lib.mkIf (pkgs.system == "x86_64-linux") {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };
    theme = {
      package = pkgs.adw-gtk3;
      name = "adw-gtk3";
    };
    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "GruvboxPlus";
    };
    gtk2.extraConfig = ''
      gtk-decoration-layout = appmenu:none
    '';
    gtk3 = {
      extraCss = builtins.readFile ./dots/gtk.css;
      extraConfig = {
        gtk-decoration-layout = "appmenu:none";
      };
    };
    gtk4 = {
      extraCss = builtins.readFile ./dots/gtk.css;
      extraConfig = {
        gtk-decoration-layout = "appmenu:none";
      };
    };
  };
  home = {
    pointerCursor = lib.mkIf (pkgs.system == "x86_64-linux") {
      gtk.enable = true;
      x11.enable = true;
      name = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.bibata-cursors;
    };

    username = "zcoyle";
    stateVersion = "24.05";
    packages = with pkgs;
      [
        act
        asciinema
        alejandra
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
        zstd
      ]
      ++ lib.optionals (pkgs.system == "x86_64-linux") [
        android-studio
        avizo
        brightnessctl
        buildah
        calibre
        copyq
        foliate
        gnome.nautilus
        kdenlive
        kickoff
        libreoffice
        playerctl
        swww
        ulauncher
        unzip
        vimiv-qt
        waypipe
        wl-clipboard
      ];
  };

  services.avizo.enable = pkgs.system == "x86_64-linux";

  wayland.windowManager.hyprland = {
    enable = pkgs.system == "x86_64-linux";
    extraConfig = ''
      exec-once = copyq --start-server
      exec-once = swww init
      exec-once = swww img ~/Pictures/wallpaper/`ls ~/Pictures/wallpaper | shuf -n 1`
      exec-once = hyprctl setcursor Bibata-Modern-Classic 24

      layerrule = blur, waybar
      layerrule = blur, wofi
      layerrule = blur, alacritty

      bind = SUPER, F, exec, firefox
      bind = SUPER, N, exec, nyxt
      bind = SUPER, A, exec, alacritty
      bind = SUPER, W, killactive
      bind = SUPER, T, togglefloating
      bind = SUPER, P, exec, swww img ~/Pictures/wallpaper/`ls ~/Pictures/wallpaper | shuf -n 1` --transition-type center
      bind = SUPER, SPACE, exec, wofi --show=run
      bind=SUPER_SHIFT,S,movetoworkspace,special
      bind=SUPER,S,togglespecialworkspace,

      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      bind = SUPER, 4, workspace, 4
      bind = SUPER, 5, workspace, 5
      bind = SUPER, 6, workspace, 6
      bind = SUPER, 7, workspace, 7
      bind = SUPER, 8, workspace, 8
      bind = SUPER, 9, workspace, 9
      bind = SUPER, 0, workspace, 10

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

      bind = SUPER, H, movefocus, l
      bind = SUPER, J, movefocus, d
      bind = SUPER, K, movefocus, u
      bind = SUPER, L, movefocus, r

      bind = SUPERSHIFT, H, swapwindow, l
      bind = SUPERSHIFT, J, swapwindow, d
      bind = SUPERSHIFT, K, swapwindow, u
      bind = SUPERSHIFT, L, swapwindow, r

      bind = SUPERALT, H, resizeactive, 10
      bind = SUPERALT, J, resizeactive, 10
      bind = SUPERALT, K, resizeactive, 10
      bind = SUPERALT, L, resizeactive, 10

      bind = SUPERALT, 1, movetoworkspacesilent, 1
      bind = SUPERALT, 2, movetoworkspacesilent, 2
      bind = SUPERALT, 3, movetoworkspacesilent, 3
      bind = SUPERALT, 4, movetoworkspacesilent, 4

      bind = SUPER, TAB, cyclenext
      bind = SUPERSHIFT, TAB, cyclenext, prev

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
      gestures = {
        workspace_swipe = true;
        workspace_swipe_fingers = 4;
      };
      input = {
        # https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
        kb_options = "caps:escape";
        natural_scroll = true;
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
    swaylock = {
      enable = pkgs.system == "x86_64-linux";
      package = pkgs.swaylock-effects;
      settings = {
        color = "808080";
        font-size = 24;
        indicator-idle-visible = false;
        indicator-radius = 100;
        line-color = "ffffff";
        show-failed-attempts = true;
      };
    };
    obs-studio = {
      enable = pkgs.system == "x86_64-linux";
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vkcapture
        obs-source-switcher
        obs-shaderfilter
        obs-move-transition
      ];
    };
    wofi = {
      enable = pkgs.system == "x86_64-linux";
      settings = {};
      style = builtins.readFile ./dots/wofi.css;
    };
    waybar = {
      enable = pkgs.system == "x86_64-linux";
      settings = {
        mainBar = {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [
            "hyprland/window"
          ];
          modules-center = [
            "hyprland/workspaces"
          ];
          modules-right = [
            "pulseaudio"
            "bluetooth"
            "network"
            "battery"
            "clock"
          ];
          "hyprland/window" = {
            icon = true;
          };
        };
      };
      style = builtins.readFile ./dots/waybar.css;
      systemd.enable = true;
    };

    wlogout.enable = pkgs.system == "x86_64-linux";

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

    chromium.enable = pkgs.system == "x86_64-linux";

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
    zathura.enable = true;
  };

  imports = [
    nixvim.homeManagerModules.nixvim
  ];
}
