{
  pkgs,
  lib,
  nixvim,
  hycov,
  config,
  ...
}: let
  # base16 styleguide:
  # https://github.com/chriskempson/base16/blob/main/styling.md
  colorsWithHashtag = config.lib.stylix.colors.withHashtag;
  tomlFormat = pkgs.formats.toml {};
in {
  stylix = {
    targets.nixvim.enable = false;
  };
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
    gtk2.extraConfig = ''
      gtk-decoration-layout=:menu,appmenu
    '';
    gtk3.extraConfig = {
      gtk-decoration-layout = ''
        gtk-decoration-layout=:menu,appmenu
      '';
    };
    gtk4.extraConfig = {
      gtk-decoration-layout = ''
        gtk-decoration-layout=:menu,appmenu
      '';
    };
    iconTheme = {
      package = pkgs.gruvbox-plus-icons;
      name = "GruvboxPlus";
    };
  };

  xdg = lib.mkIf (pkgs.system == "x86_64-linux") {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations.added = {
        # "mimetype1" = ["foo1.desktop" "foo2.desktop" "foo3.desktop"];
        # "mimetype2" = "foo4.desktop";
      };
      defaultApplications = {
        # "mimetype1" = ["default1.desktop" "default2.desktop"];
      };
    };
    portal = {
      enable = true;
      config = {
        # TODO:
        # portals.conf(5)
        XDG_CURRENT_DESKTOP = "Hyprland";
      };
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-hyprland
      ];
    };
  };

  home = {
    username = "zcoyle";
    stateVersion = "24.05";
    packages = with pkgs;
      [
        act
        alejandra
        asciinema
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
        lsix
        manix
        mdcat
        moreutils
        neovide
        nix-melt
        nix-top
        opentofu
        oterm
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
        blender
        blueman
        bottles
        brightnessctl
        buildah
        calibre
        copyq
        cura
        foliate
        freecad
        gnome.nautilus
        godot3
        grim
        imagemagick
        inkscape
        kdenlive
        kickoff
        krita
        libnotify
        libreoffice
        libsForQt5.plasma-systemmonitor
        (
          builtins.trace ''

            OLLAMA VERSION ${ollama.version}
            https://github.com/NixOS/nixpkgs/issues/280030
            turn on rocm when ${ollama.version} == 0.1.23

          ''
          ollama
        ) # Broken on darwin
        pavucontrol
        playerctl
        slurp
        swww
        ueberzugpp
        ulauncher
        unzip
        vimiv-qt
        waypipe
        wl-clipboard
        yofi
      ];

    file = {
      ".config/yofi/blacklist".text = ''
      '';
      ".config/yofi/yofi.config".source = tomlFormat.generate "yofi.config" {
        # TODO: theme w/ stylix
        width = 400;
        height = 512;
        force_window = false;
        corner_radius = "10";
        font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
        font_size = 24;
        bg_color = colorsWithHashtag.base00;
        bg_border_color = colorsWithHashtag.base04;
        bg_border_width = 4.0;
        font_color = colorsWithHashtag.base04;
        # scale = 2;
        term = "alacritty -e";
        input_text = {
          font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
          font_color = colorsWithHashtag.base01;
          bg_color = colorsWithHashtag.base04;
          margin = "5";
          padding = "1.7 -4";
          corner_radius = "10";
        };
        list_items = {
          font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
          font_color = colorsWithHashtag.base04;
          selected_font_color = colorsWithHashtag.base0B;
          match_color = colorsWithHashtag.base0F;
          margin = "5 10";
          hide_actions = true;
          action_left_margin = 60;
          item_spacing = 2;
          icon_spacing = 5;
        };
        icon = {
          size = 16;
          theme = "Adwaita";
          # fallback_icon_path = "";
        };
      };
    };
  };

  services = {
    avizo.enable = pkgs.system == "x86_64-linux";
    batsignal.enable = pkgs.system == "x86_64-linux";
    mako = {
      enable = pkgs.system == "x86_64-linux";
      borderRadius = 10;
      defaultTimeout = 2000;
      # groupBy = TODO:
      # iconPath = TODO:
      # font = TODO:
      layer = "overlay";
      # sort = TODO:
    };
  };

  wayland.windowManager.hyprland = import ./users/zcoyle/by-app/Hyprland {inherit pkgs hycov;};

  programs = {
    eww = {
      enable = pkgs.system == "x86_64-linux";
      configDir = ./dots/eww;
    };

    swaylock = {
      enable = pkgs.system == "x86_64-linux";
      package = pkgs.swaylock-effects;
      settings = {
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
        # obs-xdg-portal # might need to be packaged
        advanced-scene-switcher
        input-overlay
        obs-3d-effect
        # obs-backgroundremoval # build failing
        obs-command-source
        obs-composite-blur
        obs-move-transition
        obs-mute-filter
        obs-pipewire-audio-capture
        obs-shaderfilter
        obs-source-switcher
        obs-vkcapture
        wlrobs
      ];
    };

    waybar = import ./users/zcoyle/by-app/waybar.nix {inherit pkgs config;};

    wlogout = {
      # TODO: Styling
      enable = pkgs.system == "x86_64-linux";
      layout = [
        {
          label = "lock";
          action = "swaylock";
          text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "Logout";
          keybind = "o";
        }
        {
          # TODO: command and binding
          label = "suspend";
          action = "";
          text = "Suspend";
          keybind = "";
        }
        {
          # TODO: command and binding
          label = "hibernate";
          action = "";
          text = "Hibernate";
          keybind = "";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "Shutdown";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "Reboot";
          keybind = "r";
        }
      ];
    };

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
      profiles.zcoyle = {
        extensions = with pkgs.nur.repos.rycee.firefox-addons; [
          firenvim
          react-devtools
          reduxdevtools
          stylus
          ublock-origin
          vimium
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

    nixvim = import ./users/zcoyle/by-app/nixvim.nix {inherit pkgs config;};

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
        # {plugin = gruvbox;}
        {plugin = mode-indicator;}
      ];
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
