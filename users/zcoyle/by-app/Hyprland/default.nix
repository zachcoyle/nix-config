{pkgs, ...}: {
  enable = pkgs.stdenv.isLinux;
  plugins = [];

  extraConfig = ''
  '';

  settings = {
    general = {
      layout = "dwindle";
      cursor_inactive_timeout = 5;
    };
    plugin = {};
    decoration = {
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
      workspace_swipe_min_speed_to_force = 25;
      workspace_swipe_cancel_ratio = 0.3;
    };
    input = {
      # NOTE: https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
      kb_layout = "us, us";
      kb_options = "caps:escape,grp:alt_space_toggle,terminate:ctrl_alt_bksp";
      kb_variant = ", colemak";
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

    # INFO:
    # https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h

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
      "SUPER, B, exec, firefox"
      "SUPER, Return, exec, alacritty"
      "SUPER, Q, killactive"
      "SUPER, Y, fullscreen, 0"
      "SUPER, U, fakefullscreen, 0"
      "SUPER, T, togglefloating"
      "SUPER, O, exec, swww clear"
      "SUPER, SPACE, exec, yofi"
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
      "SUPER_SHIFT, 4, exec, grim -g \"$(slurp)\""
      "SUPER_SHIFT, 3, exec, grim"

      "SUPERALT, L, movetoworkspacesilent, +1"
      "SUPERALT, H, movetoworkspacesilent, -1"

      "SUPERALT, 1, movetoworkspacesilent, 1"
      "SUPERALT, 2, movetoworkspacesilent, 2"
      "SUPERALT, 3, movetoworkspacesilent, 3"
      "SUPERALT, 4, movetoworkspacesilent, 4"
      "SUPERALT, 5, movetoworkspacesilent, 5"
      "SUPERALT, 6, movetoworkspacesilent, 6"
      "SUPERALT, 7, movetoworkspacesilent, 7"
      "SUPERALT, 8, movetoworkspacesilent, 8"
      "SUPERALT, 9, movetoworkspacesilent, 9"
      "SUPERALT, 0, movetoworkspacesilent, 10"

      "SUPER, TAB, cyclenext"
      "SUPERSHIFT, TAB, cyclenext, prev"

      "SUPER, period, layoutmsg, orientationnext"
      "SUPER, comma, layoutmsg, orientationprev"
      "SUPERSHIFT, semicolon, exec, hyprlock"

      "SUPER, D, exec, hyprctl keyword general:layout \"dwindle\""
      "SUPER, M, exec, hyprctl keyword general:layout \"master\""

      "SUPER, H, movefocus, l"
      "SUPER, J, movefocus, d"
      "SUPER, K, movefocus, u"
      "SUPER, L, movefocus, r"

      "SUPERSHIFT, H, swapwindow, l"
      "SUPERSHIFT, J, swapwindow, d"
      "SUPERSHIFT, K, swapwindow, u"
      "SUPERSHIFT, L, swapwindow, r"
    ];

    binde = [
      "ALT, L, resizeactive, 10 0"
      "ALT, H, resizeactive, -10 0"
      "ALT, K, resizeactive, 0 -10"
      "ALT, J, resizeactive, 0 10"
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];

    bindl = [
      ", switch:Lid Switch, exec, hyprlock"
      ", XF86AudioPrev, exec, playerctl previous"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioMute, exec, volumectl toggle-mute"
    ];

    bindle = [
      ", XF86AudioRaiseVolume, exec, volumectl -u up"
      ", XF86AudioLowerVolume, exec, volumectl -u down"

      ", XF86MonBrightnessUp, exec, lightctl up"
      ", XF86MonBrightnessDown, exec, lightctl down"

      ", XF86KbdBrightnessUp, exec, brightnessctl -d \":white:kbd_backlight\" s 10%+"
      ", XF86KbdBrightnessDown, exec, brightnessctl -d \":white:kbd_backlight\" s 10%-"
    ];

    workspace = [
      "special:scratchpad, on-created-empty:alacritty"
    ];

    layerrule = [
      "blur, waybar"
      "blur, yofi"
      "blur, alacritty"
      "blur, wlogout"
      "blur, avizo"
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
      "waybar"
      # TODO:
      # "eww daemon"
      # "eww open topbar"
      "libinput-gestures"
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      # INFO: https://github.com/NixOS/nixpkgs/issues/189851
      "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
      "nm-applet"
    ];

    env = [
      "NIXOS_OZONE_WL, 1"
    ];
  };
  xwayland.enable = true;
}
