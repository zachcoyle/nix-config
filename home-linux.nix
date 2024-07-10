{
  pkgs,
  lib,
  config,
  ...
}:
let
  random-emoji = pkgs.callPackage ./packages/random-emoji.nix { };
in
{
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
    desktopEntries = {
      apple_music = {
        name = "Apple Music";
        type = "Application";
        terminal = false;
        exec = ''${lib.getExe pkgs.firefox-bin} -P "apple_music" --no-remote --kiosk=https://beta.music.apple.com/us/browse'';
        icon = ./theme/apple_music.png;
      };
    };
    mime.enable = true;
    mimeApps = {
      enable = true;
      associations = {
        added = { };
        removed = {
          "inode/directory" = [ "codium.desktop" ];
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
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      xdgOpenUsePortal = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
    };
  };
  home = {
    packages = with pkgs; [
      android-studio
      apostrophe
      appimage-run
      armcord
      blender
      bottles
      brightnessctl
      bruno
      buildah
      calibre
      cider
      copyq
      cura
      element-desktop
      evince
      foliate
      freecad
      gnome-calculator
      gnome-font-viewer
      gnome-keyring
      gnome-system-monitor
      gnome-tecla
      godot3
      grim
      handbrake
      helvum
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
      librepcb
      logos
      makemkv
      nautilus
      nautilus-python
      networkmanagerapplet
      nitch
      nvtopPackages.amd
      ollama
      parted
      pasystray
      pavucontrol
      pdfarranger
      playerctl
      quickshell
      random-emoji
      showmethekey
      slurp
      snapshot
      swayimg
      swaynotificationcenter
      swww
      thunderbird-bin
      transmission_4-gtk
      udiskie
      ueberzugpp
      unzip
      vlc
      waypipe
      wdisplays
      wev
      wf-recorder
      wl-clipboard
      wlsunset
      xdg-utils
      yubikey-touch-detector
      zenity
    ];

    file = {
      ".config/quickshell" = {
        source = ./users/zcoyle/dots/quickshell;
        recursive = true;
      };
      ".local/share/neovide/neovide-settings.json".text = import ./users/zcoyle/by-app/neovide.nix;
      ".config/swaync/style.css".source = ./users/zcoyle/dots/swaync/style.css;
      ".config/libinput-gestures.conf".source = ./users/zcoyle/dots/libinput-gestures.conf;
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
            remap = { };
          }
        ];
      };
    };
  };

  wayland.windowManager.hyprland = import ./users/zcoyle/by-app/Hyprland { inherit pkgs lib config; };

  programs = {
    ags = {
      enable = true;
      package = pkgs.ags;
      configDir = ./users/zcoyle/dots/ags;
      extraPackages = [ ];
    };

    firefox.package = pkgs.wrapFirefox pkgs.firefox-bin-unwrapped {
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

    foot = {
      enable = true;
      settings = {
        main.term = "xterm-256color";
        mouse.hide-when-typing = "yes";
      };
    };

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
            noise = 5.85e-3;
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

    rofi = import ./users/zcoyle/by-app/rofi.nix { inherit pkgs lib config; };

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
