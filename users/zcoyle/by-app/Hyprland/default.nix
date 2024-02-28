{
  pkgs,
  hycov,
  ...
}: let
  wallpaperDir = ../../../../theme/wallpapers;
in {
  enable = pkgs.stdenv.isLinux;
  plugins = [
    hycov.packages.${pkgs.system}.hycov
  ];
  extraConfig = ''


    layerrule = blur, waybar
    layerrule = blur, rofi
    layerrule = blur, alacritty
    layerrule = blur, wlogout
    layerrule = blur, avizo

    windowrule = float, wlogout
    windowrule = noanim, wlogout
    windowrule = fullscreen, wlogout

    windowrule = opacity 1.0 override 1.0 override, title:^Picture-in-Picture$


    bindl = , XF86AudioRaiseVolume, exec, volumectl -u up
    bindl = , XF86AudioLowerVolume, exec, volumectl -u down
    bindl = , XF86AudioMute, exec, volumectl toggle-mute

    bindl = , XF86MonBrightnessUp, exec, lightctl up
    bindl = , XF86MonBrightnessDown, exec, lightctl down

    bindl = , XF86AudioPrev, exec, playerctl previous
    bindl = , XF86AudioPlay, exec, playerctl play-pause
    bindl = , XF86AudioNext, exec, playerctl next

    bindl = , XF86KbdBrightnessUp, exec, brightnessctl -d ":white:kbd_backlight" s 10%+
    bindl = , XF86KbdBrightnessDown, exec, brightnessctl -d ":white:kbd_backlight" s 10%-

    bind = SUPER, H, movefocus, l
    bind = SUPER, J, movefocus, d
    bind = SUPER, K, movefocus, u
    bind = SUPER, L, movefocus, r

    bind = SUPERSHIFT, H, swapwindow, l
    bind = SUPERSHIFT, J, swapwindow, d
    bind = SUPERSHIFT, K, swapwindow, u
    bind = SUPERSHIFT, L, swapwindow, r

    binde = ALT, L, resizeactive, 10 0
    binde = ALT, H, resizeactive, -10 0
    binde = ALT, K, resizeactive, 0 -10
    binde = ALT, J, resizeactive, 0 10

    bind = SUPERALT, L, movetoworkspacesilent, +1
    bind = SUPERALT, H, movetoworkspacesilent, -1

    bind = SUPER, N, workspace, +1
    bind = SUPER, B, workspace, -1

    bind = SUPERALT, 1, movetoworkspacesilent, 1
    bind = SUPERALT, 2, movetoworkspacesilent, 2
    bind = SUPERALT, 3, movetoworkspacesilent, 3
    bind = SUPERALT, 4, movetoworkspacesilent, 4
    bind = SUPERALT, 5, movetoworkspacesilent, 5
    bind = SUPERALT, 6, movetoworkspacesilent, 6
    bind = SUPERALT, 7, movetoworkspacesilent, 7
    bind = SUPERALT, 8, movetoworkspacesilent, 8
    bind = SUPERALT, 9, movetoworkspacesilent, 9
    bind = SUPERALT, 0, movetoworkspacesilent, 10

    bind = SUPER, TAB, cyclenext
    bind = SUPERSHIFT, TAB, cyclenext, prev

    bind = SUPER, period, layoutmsg, orientationnext
    bind = SUPER, comma, layoutmsg, orientationprev
    bind = SUPERSHIFT, semicolon, exec, swaylock

    bind = SUPER, D, exec, hyprctl keyword general:layout "dwindle"
    bind = SUPER, M, exec, hyprctl keyword general:layout "master"

    bind = ALT, tab, hycov:toggleoverview
    bind = ALT, left, hycov:movefocus, l
    bind = ALT, right, hycov:movefocus, r
    bind = ALT, up, hycov:movefocus, u
    bind = ALT, down, hycov:movefocus, d

    monitor = DP-1, preferred, auto, 1
    monitor = DP-6, preferred, auto, 1

    env = NIXOS_OZONE_WL, 1
  '';
  settings = {
    general = {
      layout = "dwindle";
    };
    plugin = {
      hycov = {
        # TODO: maybe turn this on while using a mouse
        enable_hotarea = 0;
        enable_gesture = 1;
        swipe_fingers = 3;
      };
    };
    decoration = {
      # "col.shadow" = "rgba(00000099)";
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

    "$mod" = "SUPER";

    bind = [
      "SUPER, F, exec, firefox"
      "SUPER, A, exec, alacritty"
      "SUPER, Q, killactive"
      "SUPER, Y, fullscreen, 0"
      "SUPER, U, fakefullscreen, 0"
      "SUPER, T, togglefloating"
      "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 2622,1470" # 3072,1920
      "SUPER, O, exec, swww clear"
      "SUPER, SPACE, exec, rofi -show combi -show-icons"
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
    ];

    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
    bindl = [
      ", switch:Lid Switch, exec, swaylock"
    ];
    workspace = [
      "special:scratchpad, on-created-empty:alacritty"
    ];
    exec-once = [
      "copyq --start-server"
      "swww init"
      "swww img ${wallpaperDir}/platform.jpg --transition-fps 60 --transition-type grow --transition-pos 2622,1470"
      "waybar"
      # TODO:
      # "eww daemon"
      # "eww open topbar"
      "libinput-gestures"
      "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
      # INFO: https://github.com/NixOS/nixpkgs/issues/189851
      "systemctl --user import-environment PATH && systemctl --user restart xdg-desktop-portal.service"
    ];
  };
  xwayland.enable = true;
}
