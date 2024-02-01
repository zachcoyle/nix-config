{pkgs, ...}: {
  enable = pkgs.system == "x86_64-linux";
  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      modules-left = [
        "hyprland/window"
      ];
      modules-center = [
        "hyprland/workspaces"
      ];
      modules-right = [
        "pulseaudio"
        "bluetooth"
        "network"
        "battery"
        "clock"
      ];
      "hyprland/window" = {
        icon = true;
      };
    };
  };
  style = builtins.readFile ./waybar.css;
  systemd.enable = true;
}
