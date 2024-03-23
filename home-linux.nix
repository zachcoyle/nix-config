{
  pkgs,
  config,
  hyprland-plugins,
  ...
}: let
  # base16 styleguide:
  # https://github.com/chriskempson/base16/blob/main/styling.md
  colorsWithHashtag = config.lib.stylix.colors.withHashtag;
  tomlFormat = pkgs.formats.toml {};
in {
  qt = {
    enable = true;
    platformTheme = "gtk";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };
  gtk = {
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
      # TODO: swap the icon theme out later
      package = pkgs.gnome.adwaita-icon-theme;
      name = "Adwaita";
    };
  };

  xdg = {
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
        # INFO:
        # portals.conf(5)
        Hyprland = {
          default = [
            "Hyprland"
            "gtk"
          ];
          "org.freedesktop.impl.portal.Secret" = [
            "gnome-keyring"
          ];
        };
      };
      xdgOpenUsePortal = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
    };
  };
  home = {
    packages = with pkgs; [
      # darling
      # darling-dmg
      ags
      android-studio
      appimage-run
      blender
      brightnessctl
      bruno
      buildah
      calibre
      cider
      copyq
      cura
      foliate
      freecad
      gnome-tecla
      gnome.gnome-calculator
      gnome.gnome-keyring
      gnome.gnome-system-monitor
      gnome.nautilus
      godot3
      grim
      hyprshade
      imagemagick
      imv
      inkscape
      kdenlive
      kickoff
      krita
      libinput-gestures
      libnotify
      libreoffice
      makemkv
      networkmanagerapplet
      nitch
      nvtopPackages.amd
      ollama
      parted
      pavucontrol
      playerctl
      pyprland
      showmethekey
      slurp
      snapshot
      swaynotificationcenter
      swww
      udiskie
      ueberzugpp
      ulauncher
      unzip
      vlc
      waypipe
      wdisplays
      wl-clipboard
      xdg-utils
      yofi
    ];

    file = {
      ".config/ags".source = ./users/zcoyle/dots/ags;
      ".config/libinput-gestures.conf".source = ./users/zcoyle/dots/libinput-gestures.conf;
      ".config/yofi/blacklist".text = ''
      '';
      ".config/hypr/pyprland.toml".source = tomlFormat.generate "pyprland.toml" {
        pyprland = {
          plugins = [
            "expose"
            "magnify"
          ];
        };
        expose = {
          include_special = false;
        };
      };
      ".config/yofi/yofi.config".source = tomlFormat.generate "yofi.config" {
        width = 400;
        height = 512;
        force_window = false;
        corner_radius = "10";
        font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
        font_size = 24;
        bg_color = "${colorsWithHashtag.base00}BD";
        bg_border_color = colorsWithHashtag.base0A;
        bg_border_width = 4.0;
        font_color = colorsWithHashtag.base04;
        term = "alacritty -e";
        input_text = {
          font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
          font_color = colorsWithHashtag.base01;
          bg_color = "${colorsWithHashtag.base04}BD";
          margin = "10";
          padding = "4 0";
          corner_radius = "10";
        };
        list_items = {
          font = "${pkgs.fira}/share/fonts/opentype/FiraSans-Regular.otf";
          font_color = colorsWithHashtag.base04;
          selected_font_color = colorsWithHashtag.base0B;
          match_color = colorsWithHashtag.base0F;
          margin = "12 10";
          hide_actions = true;
          action_left_margin = 60;
          item_spacing = 8;
          icon_spacing = 5;
        };
        icon = {
          size = 32;
          fallback_icon_path = "/run/current-system/sw/share/icons";
        };
      };
    };
  };

  services = {
    avizo.enable = true;
    batsignal.enable = true;
    hypridle = {
      enable = true;
      lockCmd = "hyprlock";
      # unlockCmd = "";
      # afterSleepCmd = "";
      beforeSleepCmd = "playerctl pause";
    };
  };

  wayland.windowManager.hyprland = import ./users/zcoyle/by-app/Hyprland {inherit pkgs hyprland-plugins;};

  programs = {
    hyprlock = {
      enable = true;
      backgrounds = [
        {
          path = "screenshot";
          blur_passes = 1;
          blur_size = 7;
          noise = 0.00585;
        }
      ];
      labels = [
        {
          text = ''cmd[update:10000] curl -s --connect-timeout 10 https://www.biblegateway.com/votd/get/\?format\=json\&version\=ESV | jq "(.votd.reference + \" \" + .votd.text)" | fold -w 120 -s | html2text | recode html'';
        }
      ];
    };

    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # advanced-scene-switcher
        # obs-backgroundremoval
        # obs-xdg-portal
        input-overlay
        obs-3d-effect
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

    eww = {
      enable = true;
      configDir = ./users/zcoyle/by-app/eww;
    };

    waybar = import ./users/zcoyle/by-app/waybar.nix {inherit pkgs config;};

    wlogout = {
      # TODO: Styling
      enable = true;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
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

    # chromium.enable = true;

    zsh.shellAliases = {
      open = "xdg-open";
    };
  };
}
