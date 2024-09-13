{pkgs, ...}: {
  home = {
    file = {
      "Library/Application\ Support/neovide/neovide-settings.json".text = import ./users/zcoyle/by-app/neovide.nix;
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
      ".config/karabiner/karabiner.json".text = builtins.toJSON {
        global = {
          ask_for_confirmation_before_quitting = true;
          check_for_updates_on_startup = true;
          show_in_menu_bar = true;
          show_profile_name_in_menu_bar = true;
          unsafe_ui = false;
        };

        profiles = [
          {
            complex_modifications = {
              parameters = {
                "basic.simultaneous_threshold_milliseconds" = 50;
                "basic.to_delayed_action_delay_milliseconds" = 500;
                "basic.to_if_alone_timeout_milliseconds" = 1000;
                "basic.to_if_held_down_threshold_milliseconds" = 500;
                "mouse_motion_to_scroll.speed" = 100;
              };
              rules = [
                {
                  description = "Tap Caps Lock for ESC or Hold for Control";
                  manipulators = [
                    {
                      from = {
                        key_code = "caps_lock";
                        modifiers = {
                          optional = ["any"];
                        };
                      };
                      to = [
                        {
                          key_code = "left_control";
                          lazy = true;
                        }
                      ];
                      to_if_alone = [{key_code = "escape";}];
                      type = "basic";
                    }
                  ];
                  title = "Tap Caps Lock for ESC or Hold for Control";
                }
              ];
            };

            devices = [];
            fn_function_keys = [
              {
                from.key_code = "f1";
                to = [{consumer_key_code = "display_brightness_decrement";}];
              }
              {
                from.key_code = "f2";
                to = [{consumer_key_code = "display_brightness_increment";}];
              }
              {
                from.key_code = "f3";
                to = [{apple_vendor_keyboard_key_code = "mission_control";}];
              }
              {
                from.key_code = "f4";
                to = [{apple_vendor_keyboard_key_code = "spotlight";}];
              }
              {
                from.key_code = "f5";
                to = [{consumer_key_code = "dictation";}];
              }
              {
                from.key_code = "f6";
                to = [{key_code = "f6";}];
              }
              {
                from.key_code = "f7";
                to = [{consumer_key_code = "rewind";}];
              }
              {
                from.key_code = "f8";
                to = [{consumer_key_code = "play_or_pause";}];
              }
              {
                from.key_code = "f9";
                to = [{consumer_key_code = "fast_forward";}];
              }
              {
                from.key_code = "f10";
                to = [{consumer_key_code = "mute";}];
              }
              {
                from.key_code = "f11";
                to = [{consumer_key_code = "volume_decrement";}];
              }
              {
                from.key_code = "f12";
                to = [{consumer_key_code = "volume_increment";}];
              }
            ];

            name = "Default profile";

            parameters = {
              delay_milliseconds_before_open_device = 1000;
            };

            selected = true;
            simple_modifications = [];
            virtual_hid_keyboard = {
              country_code = 0;
              indicate_sticky_modifier_keys_state = true;
              mouse_key_xy_scale = 100;
            };
          }
        ];
      };
    };

    packages = with pkgs; [karabiner-elements];
  };

  programs = {
    firefox.package = pkgs.firefox-bin;
  };
}
