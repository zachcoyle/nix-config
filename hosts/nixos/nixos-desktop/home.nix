let
  wallpaperDir = ../../../theme/wallpapers;
in {
  home-manager.users.zcoyle.wayland.windowManager.hyprland.settings = {
    exec-once = [
      "swww img ${wallpaperDir}/platform.jpg --transition-fps 60 --transition-type grow --transition-pos 1695,855"
    ];
    bind = [
      "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 1695,855"
    ];
    monitor = [
      "HDMI-A-1, 1920x1080@60, 0x0, 1"
    ];
  };
}
