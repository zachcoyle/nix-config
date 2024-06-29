{
  pkgs,
  lib,
  config,
  ...
}:
let
  gradient_border = "rgb(${config.lib.stylix.colors.base0C}) rgb(${config.lib.stylix.colors.base0D}) 45deg";
  toggle_recording =
    pkgs.writeScriptBin "toggle_recording.sh" # sh
      ''
        PID="$(pidof wf-recorder)"

        if [ -n "$PID" ]; then
            kill -s INT "$PID"
        else
            wf-recorder -g "$(slurp)" -f "$XDG_VIDEOS_DIR/recording_$(date +"%Y-%m-%d_%H:%M:%S.mp4")"
        fi
      '';
in
{
  enable = pkgs.stdenv.isLinux;

  settings = {
    general = {
      gaps_out = "8,20,20,20";
      layout = "dwindle";
      "col.active_border" = lib.mkForce gradient_border;
    };
    cursor = {
      inactive_timeout = 5;
    };
    misc = {
      enable_swallow = true;
      swallow_regex = [
        "^(kitty)$"
        "^(Alacritty)$"
      ];
    };
    animations = {
      enabled = true;
      bezier = [
        "wind, 0.05, 0.9, 0.1, 1.05"
        "winIn, 0.1, 1.1, 0.1, 1.1"
        "winOut, 0.3, -0.3, 0, 1"
        "liner, 1, 1, 1, 1"
        "linear, 0.0, 0.0, 1.0, 1.0"
      ];
      animation = [
        "windowsIn, 1, 6, winIn, slide"
        "windowsOut, 1, 5, winOut, slide"
        "windowsMove, 1, 5, wind, slide"
        "border, 1, 10, default"
        "borderangle, 1, 100, linear, loop"
        "fade, 1, 10, default"
        "workspaces, 1, 5, wind"
        "windows, 1, 6, wind, slide"
      ];
    };
    decoration = {
      active_opacity = 1.0;
      drop_shadow = true;
      inactive_opacity = 0.8;
      rounding = 10;
      shadow_offset = "0 5";
      dim_inactive = true;
      blur = {
        size = 4;
        passes = 2;
      };
    };
    group = {
      "col.border_locked_active" = lib.mkForce gradient_border;
      "col.border_active" = lib.mkForce gradient_border;
      groupbar = {
        font_family = "Fira Sans";
        font_size = 12;
        text_color = lib.mkForce "rgba(${config.lib.stylix.colors.base07}CC)";
        "col.active" = lib.mkForce "rgba(${config.lib.stylix.colors.base00}CC)";
        "col.inactive" = lib.mkForce "rgba(${config.lib.stylix.colors.base03}CC)";
        "col.locked_active" = lib.mkForce "rgba(${config.lib.stylix.colors.base09}CC)";
        "col.locked_inactive" = lib.mkForce "rgba(${config.lib.stylix.colors.base08}CC)";
        height = 22;
      };
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
      workspace_swipe_min_speed_to_force = 25;
      workspace_swipe_cancel_ratio = 0.3;
    };
    input = {
      # NOTE: https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
      kb_layout = "us, us, il";
      kb_options = "caps:escape,grp:alt_space_toggle";
      kb_variant = ", colemak, phonetic";
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

    # INFO: https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h

    #  bind flags
    # l -> locked, aka. works also when an input inhibitor (e.g. a lockscreen) is active.
    # r -> release, will trigger on release of a key.
    # e -> repeat, will repeat when held.
    # n -> non-consuming, key/mouse events will be passed to the active window in addition to triggering the dispatcher.
    # m -> mouse, see below
    # t -> transparent, cannot be shadowed by other binds.
    # i -> ignore mods, will ignore modifiers.

    "$mod" = "SUPER";

    bind = [
      # "SUPER, grave, hyprexpo:expo, toggle"

      "SUPER, B, exec, firefox"
      "SUPER, C, exec, rofi -opacity 0 -show calc -display-calc ''"
      "SUPER, E, exec, rofi -opacity 0 -show emoji -display-emoji `random-emoji`"
      "SUPER, Return, exec, alacritty"
      "SUPER, Q, killactive"
      "SUPER, Y, fullscreen, 0"
      "SUPER, U, fakefullscreen, 0"
      "SUPER, T, togglefloating"
      "SUPER, SPACE, exec, rofi -opacity 0 -show drun -show-icons -display-drun '' -display-ssh '󰣀' -display-run '' -display-window ''"
      "SUPER, S, togglespecialworkspace, scratchpad"
      "SUPER, 1, workspace, 1"
      "SUPER, 2, workspace, 2"
      "SUPER, 3, workspace, 3"
      "SUPER, 4, workspace, 4"
      "SUPER, 5, workspace, 5"
      "SUPER, 6, workspace, 6"
      "SUPER, 7, workspace, 7"
      "SUPER, 8, workspace, 8"
      "SUPER, 9, workspace, 9"
      "SUPER, 0, workspace, 10"
      "SUPER_SHIFT, 3, exec, grim"
      ''SUPER_SHIFT, 4, exec, grim -g "$(slurp)"''
      "SUPER_SHIFT, 5, exec, ${toggle_recording}/bin/toggle_recording.sh"

      "SUPER, G, togglegroup"
      "SUPER, N, changegroupactive"
      "SUPER SHIFT, N, changegroupactive, b"
      "SUPER, O, moveoutofgroup"
      "SUPER, semicolon, lockactivegroup, toggle"

      "SUPER_ALT, 1, movetoworkspacesilent, 1"
      "SUPER_ALT, 2, movetoworkspacesilent, 2"
      "SUPER_ALT, 3, movetoworkspacesilent, 3"
      "SUPER_ALT, 4, movetoworkspacesilent, 4"
      "SUPER_ALT, 5, movetoworkspacesilent, 5"
      "SUPER_ALT, 6, movetoworkspacesilent, 6"
      "SUPER_ALT, 7, movetoworkspacesilent, 7"
      "SUPER_ALT, 8, movetoworkspacesilent, 8"
      "SUPER_ALT, 9, movetoworkspacesilent, 9"
      "SUPER_ALT, 0, movetoworkspacesilent, 10"
      "SUPER_ALT, S, movetoworkspacesilent, special:scratchpad"

      "SUPER, TAB, cyclenext"
      "SUPER_SHIFT, TAB, cyclenext, prev"

      "SUPER, period, layoutmsg, orientationnext"
      "SUPER, comma, layoutmsg, orientationprev"
      "SUPER_SHIFT, semicolon, exec, hyprlock"

      "SUPER, D, exec, hyprctl keyword general:layout \"dwindle\""
      "SUPER, M, exec, hyprctl keyword general:layout \"master\""

      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"

      "SUPER_SHIFT, H, swapwindow, l"
      "SUPER_SHIFT, J, swapwindow, d"
      "SUPER_SHIFT, K, swapwindow, u"
      "SUPER_SHIFT, L, swapwindow, r"

      "ALT_SHIFT, H, movewindoworgroup, l"
      "ALT_SHIFT, J, movewindoworgroup, d"
      "ALT_SHIFT, K, movewindoworgroup, u"
      "ALT_SHIFT, L, movewindoworgroup, r"

      "SUPER, slash, exec, hyprpicker | wl-copy"

      "SUPER_ALT, backspace, exit"
      "SUPER, backslash, exec, sudo systemctl restart tiny-dfr"

      "SUPER, XF86Eject, exec, hyprctl kill"
    ];

    binde = [
      "ALT, L, resizeactive, 10 0"
      "ALT, H, resizeactive, -10 0"
      "ALT, K, resizeactive, 0 -10"
      "ALT, J, resizeactive, 0 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindowpixel"
      "$mod ALT, mouse:272, resizewindowpixel"
    ];

    bindl = [
      ", switch:on:Lid Switch, exec, hyprlock"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, volumectl -p toggle-mute"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, volumectl -p -u up"
      ", XF86AudioLowerVolume, exec, volumectl -p -u down"

      ", XF86MonBrightnessUp, exec, lightctl up"
      ", XF86MonBrightnessDown, exec, lightctl down"

      ", XF86KbdBrightnessUp, exec, brightnessctl -d \":white:kbd_backlight\" s 10%+"
      ", XF86KbdBrightnessDown, exec, brightnessctl -d \":white:kbd_backlight\" s 10%-"
      ", XF86Eject, exec, eject"
    ];

    workspace = [ "special:scratchpad, on-created-empty:alacritty" ];

    layerrule = [
      "blur, ags"
      "blur, alacritty"
      "blur, wlogout"
      "blur, avizo"
      "blur, rofi"
    ];

    windowrule = [
      "float, wlogout"
      "noanim, wlogout"
      "fullscreen, wlogout"
      "opacity 1.0 override 1.0 override, title:^Picture-in-Picture$"
      "nodim, title:^Picture-in-Picture$"
    ];

    exec-once = [
      "copyq --start-server"
      "swww init"
      "ags"
      "libinput-gestures"
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      # INFO: https://github.com/NixOS/nixpkgs/issues/189851
      "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
      "nm-applet"
      "blueman-applet"
      # "swaync"
      "udiskie -a -n"
      "pypr"
      "wlsunset -l 40.45 -L -85.37"
      "pasystray"
    ];

    env = [ "NIXOS_OZONE_WL, 1" ];
  };

  xwayland.enable = true;
}
