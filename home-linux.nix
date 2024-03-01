{
  pkgs,
  lib,
  config,
  hycov,
  ...
}: let
  # base16 styleguide:
  # https://github.com/chriskempson/base16/blob/main/styling.md
  colorsWithHashtag = config.lib.stylix.colors.withHashtag;
  tomlFormat = pkgs.formats.toml {};
in
  lib.mkIf pkgs.stdenv.isLinux {
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
          # TODO:
          # portals.conf(5)
          XDG_CURRENT_DESKTOP = "Hyprland";
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
        appimage-run
        blender
        bottles
        brightnessctl
        buildah
        calibre
        cider
        copyq
        cura
        foliate
        freecad
        gitkraken
        gnome-tecla
        gnome.gnome-calculator
        gnome.gnome-system-monitor
        gnome.nautilus
        godot3
        grim
        hyprshade
        imagemagick
        inkscape
        kdenlive
        kicad
        kickoff
        krita
        libinput-gestures
        libnotify
        libreoffice
        makemkv
        networkmanagerapplet
        nitch
        ollama
        pavucontrol
        playerctl
        retroarchFull
        slurp
        swww
        ueberzugpp
        ulauncher
        unzip
        vimiv-qt
        vlc
        waypipe
        wdisplays
        wl-clipboard
        xdg-utils
        yofi
      ];

      file = {
        ".config/libinput-gestures.conf".source = ./users/zcoyle/dots/libinput-gestures.conf;
        ".config/yofi/blacklist".text = ''
        '';
        ".config/yofi/yofi.config".source = tomlFormat.generate "yofi.config" {
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
            fallback_icon_path = "/run/current-system/sw/share/icons";
          };
        };
      };
    };

    services = {
      avizo.enable = true;
      batsignal.enable = true;
      mako = {
        enable = true;
        borderRadius = 10;
        defaultTimeout = 2000;
        # groupBy = TODO:
        iconPath = "/run/current-system/sw/share/icons";
        # font = TODO:
        layer = "overlay";
        # sort = TODO:
      };
    };

    wayland.windowManager.hyprland = import ./users/zcoyle/by-app/Hyprland {inherit pkgs hycov;};

    programs = {
      swaylock = {
        enable = true;
        package = pkgs.swaylock-effects;
        settings = {
          screenshots = true;
          clock = true;
          effect-blur = "7x5";
          effect-vignette = "0.5:0.5";
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 100;
          line-color = "ffffff";
          show-failed-attempts = true;
          fade-in = 0.2;
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

      # chromium.enable = true;

      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
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

        profiles.zcoyle = {
          id = 0;
          name = "zcoyle";
          extensions = with pkgs.nur.repos.rycee.firefox-addons; [
            firenvim
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
            default = "DuckDuckGo";
            engines = {
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
          '';

          userContent = ''
          '';
        };
      };
      zsh.shellAliases = {
        open = "xdg-open";
      };
    };
  }
