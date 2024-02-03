{
  pkgs,
  hycov,
  ...
}: {
  enable = pkgs.system == "x86_64-linux";
  plugins = [
    hycov.packages.${pkgs.system}.hycov
  ];
  extraConfig = ''
    # https://github.com/xkbcommon/libxkbcommon/blob/master/include/xkbcommon/xkbcommon-keysyms.h

    exec-once = copyq --start-server
    exec-once = swww init
    exec-once = swww img ~/Pictures/wallpaper/`ls ~/Pictures/wallpaper | shuf -n 1`
    # exec-once = hyprctl setcursor Bibata-Modern-Gruvbox 24

    layerrule = blur, waybar
    layerrule = blur, wofi
    layerrule = blur, alacritty

    bind = SUPER, F, exec, firefox
    bind = SUPER, A, exec, alacritty
    bind = SUPER, Q, killactive
    bind = SUPER, T, togglefloating
    bind = SUPER, P, exec, swww img ~/Pictures/wallpaper/`ls ~/Pictures/wallpaper | shuf -n 1` --transition-type center
    bind = SUPER, SPACE, exec, wofi --show=run

    workspace = special:scratchpad, on-created-empty:alacritty
    bind = SUPER_SHIFT, S, movetoworkspace, special:scratchpad
    bind = SUPER, S, togglespecialworkspace, special:scratchpad

    bind = SUPER, 1, workspace, 1
    bind = SUPER, 2, workspace, 2
    bind = SUPER, 3, workspace, 3
    bind = SUPER, 4, workspace, 4
    bind = SUPER, 5, workspace, 5
    bind = SUPER, 6, workspace, 6
    bind = SUPER, 7, workspace, 7
    bind = SUPER, 8, workspace, 8
    bind = SUPER, 9, workspace, 9
    bind = SUPER, 0, workspace, 10

    bind = SUPER_SHIFT, 4, exec, grim -g "$(slurp)"

    bind = , XF86AudioRaiseVolume, exec, volumectl -u up
    bind = , XF86AudioLowerVolume, exec, volumectl -u down
    bind = , XF86AudioMute, exec, volumectl toggle-mute

    bind = , XF86MonBrightnessUp, exec, lightctl up
    bind = , XF86MonBrightnessDown, exec, lightctl down

    bind = , XF86AudioPrev, exec, playerctl previous
    bind = , XF86AudioPlay, exec, playerctl play-pause
    bind = , XF86AudioNext, exec, playerctl next

    bind = , XF86KbdBrightnessUp, exec, brightnessctl -d ":white:kbd_backlight" s 10%+
    bind = , XF86KbdBrightnessDown, exec, brightnessctl -d ":white:kbd_backlight" s 10%-

    bind = SUPER, H, movefocus, l
    bind = SUPER, J, movefocus, d
    bind = SUPER, K, movefocus, u
    bind = SUPER, L, movefocus, r

    bind = SUPERSHIFT, H, swapwindow, l
    bind = SUPERSHIFT, J, swapwindow, d
    bind = SUPERSHIFT, K, swapwindow, u
    bind = SUPERSHIFT, L, swapwindow, r

    bind = ALT, L, resizeactive, 10 0
    bind = ALT, H, resizeactive, -10 0
    bind = ALT, K, resizeactive, 0 -10
    bind = ALT, J, resizeactive, 0 10

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

    bind = SUPER, D, exec, hyprctl keyword general:layout "dwindle"
    bind = SUPER, M, exec, hyprctl keyword general:layout "master"

    #### Plugin bindings ####

    bind = ALT, tab, hycov:toggleoverview
    bind = ALT, left, hycov:movefocus, l
    bind = ALT, right, hycov:movefocus, r
    bind = ALT, up, hycov:movefocus, u
    bind = ALT, down, hycov:movefocus, d
  '';
  settings = {
    general = {
      layout = "master";
    };
    plugin = {
      hycov = {
        # TODO: bottom left corner is a hot corner until hyprland supports more gesture config
        # enable_hotarea = 1;
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
      # screen_shader = builtins.toString ./crt.frag;
      # screen_shader = builtins.toString ./gruvbox.frag;
    };
    gestures = {
      workspace_swipe = true;
      workspace_swipe_fingers = 4;
    };
    input = {
      # INFO: https://gist.github.com/jatcwang/ae3b7019f219b8cdc6798329108c9aee
      kb_options = "caps:escape";
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
    "$mod" = "SUPER";
    bindm = [
      "$mod, mouse:272, movewindow"
      "$mod, mouse:273, resizewindow"
      "$mod ALT, mouse:272, resizewindow"
    ];
  };
  xwayland.enable = true;
}
