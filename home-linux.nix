{
  pkgs,
  pkgsStable,
  lib,
  std,
  config,
  ...
}:
let
  inherit (config.lib.stylix) colors;
  inherit (config.lib.stylix.colors) withHashtag;
  random-emoji = pkgs.callPackage ./packages/random-emoji.nix { };
in
{
  imports = [
    ./users/zcoyle/by-app/Hyprland
    ./users/zcoyle/by-app/rofi.nix
    ./users/zcoyle/by-app/walker.nix
  ];

  stylix.targets.gtk.extraCss =
    let
      base00-pct = {
        r = builtins.toString ((std.num.parseFloat colors.base00-dec-r) * 255);
        g = builtins.toString ((std.num.parseFloat colors.base00-dec-g) * 255);
        b = builtins.toString ((std.num.parseFloat colors.base00-dec-b) * 255);
      };
      base01-pct = {
        r = builtins.toString ((std.num.parseFloat colors.base01-dec-r) * 255);
        g = builtins.toString ((std.num.parseFloat colors.base01-dec-g) * 255);
        b = builtins.toString ((std.num.parseFloat colors.base01-dec-b) * 255);
      };
      cssRgba = color: "rgba(${color.r}, ${color.g}, ${color.b}, 0.8)";
    in
    ''
      @define-color window-bg-color: ${cssRgba base00-pct};
      @define-color sidebar-bg-color: ${cssRgba base01-pct};
      window { background: ${cssRgba base00-pct}; } 
      .sidebar-pane { background: ${cssRgba base01-pct}; }
    '';

  qt.enable = true;

  gtk = {
    enable = true;
    iconTheme = {
      name = "Gruvbox-Plus-Dark";
      package = pkgs.gruvbox-plus-icons;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/wm/preferences".button-layout = ":appmenu";
    "com/gitlab/bitseater/meteo" = {
      country = "US";
      idplace = "4927510";
      indicator = true;
      interval = 3600;
      location = "Matthews";
      minimized = true;
      state = "Indiana";
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
        removed = { };
      };
      defaultApplications = import ./mimetypes.nix;
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
    packages =
      with pkgs;
      [
        # android-studio
        appimage-run
        armcord
        aseprite
        audio-recorder
        blender
        # bottles
        brightnessctl
        buildah
        cider
        copyq
        evince
        gnome-calculator
        gnome-calendar
        gnome-disk-utility
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
        keepassxc
        kickoff
        krita
        libinput-gestures
        libnotify
        librepcb
        logos
        makemkv
        meteo
        nautilus
        nautilus-python
        networkmanagerapplet
        nitch
        nvtopPackages.amd
        parted
        pasystray
        pavucontrol
        pdfarranger
        playerctl
        random-emoji
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
        wf-recorder
        wl-clipboard
        wlr-which-key
        wlsunset
        xdg-utils
        yubikey-manager
        yubikey-manager-qt
        yubikey-touch-detector
        zenity
      ]
      ++ (with pkgsStable; [
        apostrophe
        calibre
        cura
        element-desktop
        foliate
        freecad
        ladybird
        libreoffice
        revolt-desktop
        transmission_4-gtk
        visidata
      ]);

    file = {
      ".config/libinput-gestures.conf".source = ./users/zcoyle/dots/libinput-gestures.conf;
      ".config/swaync/style.css".source = ./users/zcoyle/dots/swaync/style.css;
      ".config/wlr-which-key/config.yaml".text = builtins.toJSON {
        font = "Fira Sans Nerd Font";
        background = withHashtag.base00 + "cc";
        color = withHashtag.base07;
        border = withHashtag.base0C;
        separator = " ➜ ";
        border_width = 1;
        corner_r = 10;
        padding = 15;
        anchor = "center";
        margin_right = 0;
        margin_bottom = 0;
        margin_left = 0;
        margin_top = 0;
        menu = {
          h = {
            desc = "Hyprland";
            submenu = {
              e = {
                desc = "Exit";
                cmd = "hyprctl dispatch exit";
              };
              k = {
                desc = "Kill Mode";
                cmd = "hyprctl kill";
              };
              l = {
                desc = "Layout";
                submenu = {
                  d = {
                    desc = "Dwindle";
                    cmd = ''hyprctl keyword general:layout "dwindle"'';
                  };
                  m = {
                    desc = "Master";
                    cmd = ''hyprctl keyword general:layout "master"'';
                  };
                };
              };
              p = {
                desc = "Hyprpicker";
                cmd = "hyprpicker";
              };
            };
          };
          s = {
            desc = "Services";
            submenu = {
              t = {
                desc = "(restart) tiny-dfr";
                cmd = "sudo systemctl restart tiny-dfr";
              };
              n = {
                desc = "nh-clean.timer";
                submenu = {
                  Return = {
                    desc = "Start nh-clean.timer";
                    cmd = "sudo systemctl start nh-clean.timer";
                  };
                  x = {
                    desc = "Stop nh-clean.timer";
                    cmd = "sudo systemctl stop nh-clean.timer";
                  };
                };
              };
            };
          };
        };
      };
      ".local/share/neovide/neovide-settings.json".text = import ./users/zcoyle/by-app/neovide.nix;
    };

    shellAliases = {
      open = "xdg-open";
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
        disable_loading_bar = false;
        grace = 0;
        hide_cursor = true;
        no_fade_in = false;

        background = [
          {
            path = builtins.toString ./theme/wallpapers/calder-moore-factorycomped.jpg;
            blur_passes = 0;
            contrast = 0.8916;
            brightness = 0.8172;
            vibrancy = 0.1696;
            vibrancy_darkness = 0.0;
          }
        ];
        label = [
          {
            text = "Welcome!";
            color = "rgba(216, 222, 233, 0.75)";
            font_size = 55;
            font_family = "Fira Sans";
            position = "150, 320";
            halign = "left";
            valign = "center";
          }
          {
            text = ''cmd[update:1000] echo -e "$(date +"%A, %B %d")"'';
            color = "rgba(216, 222, 233, 0.75)";
            font_size = 19;
            font_family = "Fira Sans";
            position = "217, 175";
            halign = "left";
            valign = "right";
          }
          {
            text = "    $USER";
            color = "rgba(216, 222, 233, 0.80)";
            outline_thickness = 0;
            dots_size = 0.2;
            dots_spacing = 0.2;
            dots_center = true;
            font_size = 16;
            font_family = "Fira Sans";
            position = "275, -140";
            halign = "left";
            valign = "center";
          }
        ];
        image = [ ];
        shape = [
          {
            size = "320, 55";
            color = "rgba(255, 255, 255, 0.1)";
            rounding = -1;
            border_size = 0;
            border_color = "rgba(255, 255, 255, 1)";
            rotate = 0;
            xray = false;
            position = "160, -140";
            halign = "left";
            valign = "center";
          }
        ];
        input-field = [ ];
      };
    };

    # obs-studio = {
    #   enable = true;
    #   plugins = with pkgs.obs-studio-plugins; [
    #     input-overlay
    #     obs-3d-effect
    #     obs-command-source
    #     obs-composite-blur
    #     obs-move-transition
    #     obs-mute-filter
    #     obs-pipewire-audio-capture
    #     obs-shaderfilter
    #     obs-source-switcher
    #     obs-vkcapture
    #     wlrobs
    #   ];
    # };

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

  };

}
