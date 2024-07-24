let
  wallpaperDir = ../../../theme/wallpapers;
in
{
  home-manager.users.zcoyle = {
    # don't need this turned on w/ apple keyboard
    # services.xremap.config.modmap = [
    #   {
    #     name = "Desktop";
    #     remap = {
    #       Alt_L = "Super_L";
    #       Super_L = "Alt_L";
    #       Alt_R = "Super_R";
    #       Compose = "Alt_R"; # Menu key, see https://github.com/xremap/xremap/issues/455
    #     };
    #   }
    # ];
    wayland.windowManager.hyprland.settings = {
      # FIXME: https://github.com/hyprwm/Hyprland/issues/7001
      cursor.no_hardware_cursors = true;
      exec-once = [
        "swww img ${wallpaperDir}/platform.png --transition-fps 60 --transition-type grow --transition-pos 1695,855"
      ];
      bind = [
        "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 1695,855"
      ];
      monitor = [ "HDMI-A-1, 1920x1080@60, 0x0, 1" ];
    };
  };
}
