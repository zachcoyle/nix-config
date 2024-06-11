{
  pkgs,
  lib,
  config,
  hyprland-plugins,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
  random-emoji = pkgs.callPackage ./packages/random-emoji.nix {};
in {
  qt = {
    enable = true;
    platformTheme.name = "gtk";
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
      # TODO: make a decision between these

      # name = "Adwaita";
      # package = pkgs.gnome.adwaita-icon-theme;

      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;

      # name = "Papirus";
      # package = pkgs.papirus-icon-theme;

      # name = "Qogir";
      # package = pkgs.qogir-icon-theme;

      # name = "Tela";
      # package = pkgs.tela-icon-theme;
    };
  };

  xdg = {
    enable = true;
    userDirs.enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations = {
        added = {};
        removed = {
          "inode/directory" = ["codium.desktop"];
        };
      };
      defaultApplications = {
        "inode/directory" = "nautilus.desktop";
      };
    };
    portal = {
      enable = true;
      config = {
        # INFO: portals.conf(5)
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
      android-studio
      apostrophe
      armcord
      appimage-run
      blender
      bottles
      brightnessctl
      bruno
      buildah
      calibre
      cider
      copyq
      cura
      dwarf-fortress-packages.dwarf-fortress-full
      element-desktop
      foliate
      freecad
      gnome-tecla
      gnome.evince
      gnome.gnome-calculator
      gnome.gnome-font-viewer
      gnome.gnome-keyring
      gnome.gnome-system-monitor
      gnome.nautilus
      gnome.zenity
      godot3
      grim
      handbrake
      hyprpicker
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
      # nyxt
      ollama
      parted
      pasystray
      pavucontrol
      pdfarranger
      playerctl
      pyprland
      random-emoji
      retroarchFull
      showmethekey
      slurp
      snapshot
      swaynotificationcenter
      swww
      thunderbird-bin
      udiskie
      ueberzugpp
      unzip
      vlc
      waypipe
      wdisplays
      wev
      wl-clipboard
      wlsunset
      xdg-utils
      yubikey-touch-detector
    ];

    file = {
      ".config/swaync/style.css".source = ./users/zcoyle/dots/swaync/style.css;
      ".config/libinput-gestures.conf".source = ./users/zcoyle/dots/libinput-gestures.conf;
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
    };
  };

  services = {
    avizo.enable = true;

    batsignal.enable = true;

    hypridle = {
      enable = false;
      settings = {
        general = {
          lock_cmd = "hyprlock";
          # unlockCmd = "";
          after_sleep_cmd = "hyprctl dispatch dpms on";
          before_sleep_cmd = "playerctl pause";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };

    xremap = {
      withWlroots = true;
      watch = true;
      config = {
        modmap = [
          {
            name = "Global";
            remap = {
              CapsLock = {
                held = "Ctrl_L";
                alone = "Esc";
                alone_timeout_millis = 1000;
              };
            };
          }
        ];
        keymap = [
          {
            name = "Global";
            remap = {
            };
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = import ./users/zcoyle/by-app/Hyprland {inherit pkgs lib config hyprland-plugins;};

  programs = {
    ags = {
      enable = true;
      package = pkgs.ags;
      configDir = ./users/zcoyle/dots/ags;
      extraPackages = [];
    };

    # chromium.enable = true;

    hyprlock = {
      enable = true;

      settings = {
        disable_loading_bar = true;
        grace = 300;
        hide_cursor = true;
        no_fade_in = false;

        background = [
          {
            path = "screenshot";
            blur_passes = 1;
            blur_size = 7;
            noise = 0.00585;
          }
        ];

        label = [
          {
            text = ''cmd[update:10000] curl -s --connect-timeout 10 https://www.biblegateway.com/votd/get/\?format\=json\&version\=ESV | jq "(.votd.reference + \" \" + .votd.text)" | fold -w 120 -s | html2text | recode html'';
            rotate = 0.0;
          }
        ];
      };
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

    rofi = import ./users/zcoyle/by-app/rofi.nix {inherit pkgs lib config;};

    wlogout = {
      enable = true;
      style = ./users/zcoyle/dots/wlogout.css;
      layout = [
        {
          label = "lock";
          action = "hyprlock";
          text = "󰌾";
          # text = "Lock";
          keybind = "l";
        }
        {
          label = "logout";
          action = "hyprctl dispatch exit";
          text = "󰍃";
          keybind = "o";
        }
        {
          # TODO: command and binding
          label = "suspend";
          # action = "";
          text = "󰏤";
          # keybind = "";
        }
        {
          # TODO: command and binding
          label = "hibernate";
          # action = "";
          text = "";
          # keybind = "";
        }
        {
          label = "shutdown";
          action = "systemctl poweroff";
          text = "";
          keybind = "s";
        }
        {
          label = "reboot";
          action = "systemctl reboot";
          text = "";
          keybind = "r";
        }
      ];
    };

    zsh.shellAliases = {
      open = "xdg-open";
    };
  };
}
