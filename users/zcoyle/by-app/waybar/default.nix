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
        "cpu"
        "memory"
        "disk"
        "pulseaudio"
        "bluetooth"
        "network"
        "battery"
        "clock"
      ];
      "hyprland/window" = {
        icon = true;
      };

      battery = {
        states = {
          # good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}   {capacity}%";
        "format-charging" = "  {capacity}%";
        "format-plugged" = "  {capacity}%";
        "format-alt" = "{icon}  {time}";
        # "format-good" = ""; # An empty format will hide the module
        # "format-full" = "";
        "format-icons" = [" " " " " " " " " "];
      };

      clock = {
        timezone = "America/Indiana/Indianapolis";
        format = "{:%I:%M}";
        "format-alt" = "{:%Y-%m-%d %I:%M}";
        "tooltip-format" = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "󰻠 {usage}% ";
        "on-click" = "alacritty -e btm";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}% ";
        path = "/";
        "on-click" = "alacritty -e btm";
      };

      memory = {
        format = "󰍛 {}% ";
        "on-click" = "alacritty -e btm";
      };

      network = {
        format = "{ifname}";
        format-wifi = "   {signalStrength}%";
        format-ethernet = "  {ipaddr}";
        "format-disconnected" = "Not connected"; #An empty format will hide the module.
        "tooltip-format" = " {ifname} via {gwaddri}";
        "tooltip-format-wifi" = "   {essid} ({signalStrength}%)";
        "tooltip-format-ethernet" = "  {ifname} ({ipaddr}/{cidr})";
        "tooltip-format-disconnected" = "Disconnected";
        "max-length" = 50;
        "on-click" = "alacritty -e nmtui";
      };
    };
  };
  style = builtins.readFile ./waybar.css;
  systemd.enable = true;
}
