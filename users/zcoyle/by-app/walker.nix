{ config, ... }:
let
  inherit (config.lib.stylix) colors;
  inherit (config.lib.stylix.colors) withHashtag;
in
{

  home.file = {
    ".config/walker/themes/gruvbox.json".text = builtins.toJSON {
      ui = {
        anchors = {
          bottom = true;
          left = true;
          right = true;
          top = true;
        };
        fullscreen = true;
        ignore_exclusive = true;
        window = {
          box = {
            h_align = "center";
            v_align = "center";
            spacing = 10;
            margins = {
              bottom = 200;
              top = 200;
            };
            name = "box";
            orientation = "horizontal";
            revert = false;
            scroll = {
              h_scrollbar_policy = "automatic";
              list = {
                always_show = true;
                h_align = "fill";
                h_expand = true;
                item = {
                  activation_label = {
                    name = "activationlabel";
                    width = 20;
                    x_align = 1;
                  };
                  h_align = "fill";
                  icon = {
                    icon_size = "large";
                    name = "icon";
                    pixel_size = -1;
                    theme = "Papirus";
                    v_align = "center";
                  };
                  name = "item";
                  orientation = "horizontal";
                  revert = false;
                  spacing = 5;
                  text = {
                    h_align = "start";
                    h_expand = true;
                    label = {
                      h_align = "start";
                      h_expand = true;
                      name = "label";
                    };
                    name = "text";
                    orientation = "vertical";
                    revert = true;
                    sub = {
                      h_align = "start";
                      name = "sub";
                    };
                  };
                };
                max_height = 300;
                max_width = 400;
                min_width = 400;
                name = "list";
                orientation = "vertical";
                width = 400;
              };
              overlay_scrolling = false;
              v_scrollbar_policy = "automatic";
            };
            search = {
              input = {
                h_align = "fill";
                h_expand = true;
                icons = true;
                name = "input";
              };
              name = "search";
              revert = false;
              spacing = 10;
              spinner = {
                hide = true;
                name = "spinner";
                v_align = "fill";
              };
              v_align = "start";
              width = 400;
            };
          };
          name = "window";
          v_align = "start";
        };
      };
    };

    ".config/walker/themes/gruvbox.css".text = # css
      ''
        #window {
          background: none;
        }

        #box {
          background: ${withHashtag.base00};
          padding: 16px;
          border-radius: 8px;
          box-shadow:
            0 19px 38px rgba(0, 0, 0, 0.3),
            0 15px 12px rgba(0, 0, 0, 0.22);
        }

        scrollbar {
          background: none;
          padding-left: 8px;
        }

        slider {
          min-width: 2px;
          background: #7f849c;
          opacity: 0.5;
        }

        #search {
        }

        #password,
        #input,
        #typeahead {
          background: #363a4f;
          background: none;
          box-shadow: none;
          border-radius: 0px;
          border-radius: 32px;
          color: #c6d0f5;
          padding-left: 12px;
          padding-right: 12px;
        }

        #input {
          background: none;
        }

        #input > *:first-child,
        #typeahead > *:first-child {
          color: #7f849c;
          margin-right: 7px;
        }

        #input > *:last-child,
        #typeahead > *:last-child {
          color: #7f849c;
        }

        #spinner {
        }

        #typeahead {
          color: #89b4fa;
        }

        #input placeholder {
          opacity: 0.5;
        }

        #list {
        }

        row {
          border-radius: 8px;
          color: #cad3f5;
          padding: 4px;
        }

        row:selected {
          background: #414559;
          box-shadow: none;
          color: #cad3f5;
        }

        #item {
        }

        #icon {
        }

        #text {
        }

        #label {
          font-weight: bold;
          color: #cad3f5;
        }

        #sub {
          opacity: 0.5;
          color: #cad3f5;
        }

        #activationlabel {
          opacity: 0.5;
          padding-right: 4px;
        }

        .activation #activationlabel {
          font-weight: bold;
          color: #89b4fa;
          opacity: 1;
        }

        .activation #text,
        .activation #icon,
        .activation #search {
        }

      '';
  };

  programs.walker = {
    enable = true;
    runAsService = true;
    config = {
      activation_mode = { };
      builtins = {
        applications = {
          actions = true;
          context_aware = true;
          name = "applications";
          placeholder = "Applications";
          prioritize_new = true;
          refresh = true;
          show_sub_when_single = true;
        };
        clipboard = {
          image_height = 300;
          max_entries = 10;
          name = "clipboard";
          placeholder = "Clipboard";
          switcher_only = true;
        };
        commands = {
          name = "commands";
          placeholder = "Commands";
          switcher_only = true;
        };
        custom_commands = {
          name = "custom_commands";
          placeholder = "Custom Commands";
        };
        dmenu = {
          name = "dmenu";
          placeholder = "Dmenu";
          switcher_only = true;
        };
        emojis = {
          history = true;
          name = "emojis";
          placeholder = "Emojis";
          switcher_only = true;
          typeahead = true;
        };
        finder = {
          concurrency = 8;
          ignore_gitignore = true;
          name = "finder";
          placeholder = "Finder";
          refresh = true;
          switcher_only = true;
        };
        runner = {
          generic_entry = false;
          history = true;
          name = "runner";
          placeholder = "Runner";
          refresh = true;
          typeahead = true;
        };
        ssh = {
          history = true;
          name = "ssh";
          placeholder = "SSH";
          refresh = true;
          switcher_only = true;
        };
        switcher = {
          name = "switcher";
          placeholder = "Switcher";
          prefix = "/";
        };
        websearch = {
          engines = [ "google" ];
          name = "websearch";
          placeholder = "Websearch";
        };
        windows = {
          name = "windows";
          placeholder = "Windows";
        };
      };
      list = {
        max_entries = 50;
        show_initial_entries = true;
        single_click = true;
      };
      search = {
        delay = 0;
        force_keyboard_focus = true;
        history = true;
        placeholder = "Search...";
      };
      theme = "gruvbox";
    };
  };
}
