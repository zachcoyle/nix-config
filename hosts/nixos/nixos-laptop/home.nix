let
  wallpaperDir = ../../../theme/wallpapers;
in {
  home-manager.users.zcoyle.wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww img ${wallpaperDir}/platform.jpg --transition-fps 60 --transition-type grow --transition-pos 2622,1470"
    ];
    bind = [
      "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 2622,1470"
    ];
    monitor = [
      "DP-1, 3072x1920@60, 1920x540, 1"
      "DP-6, 1920x1080@60, 0x0, 1"
    ];
  };
}
