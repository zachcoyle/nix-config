{
  pkgs,
  config,
  ...
}: {
  enable = pkgs.system == "x86_64-linux";

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [
        "custom/logo"
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
        # "bluetooth" # TODO:
        "network"
        "battery"
        "clock"
        "custom/spacer"
        "tray"
      ];

      "hyprland/window" = {
        icon = true;
      };

      "custom/logo" = {
        format = "   ";
        on-click = "wlogout";
        on-right-click = "swaylock";
      };

      "custom/spacer" = {
        format = " ";
      };

      battery = {
        states = {
          # good = 95;
          warning = 30;
          critical = 15;
        };
        format = "{icon}   {capacity}%";
        format-charging = "󱐋 {capacity}%";
        format-plugged = " {capacity}%";
        format-alt = "{icon}  {time}";
        # format-good = ""; # An empty format will hide the module
        # format-full = "";
        format-icons = ["" "" "" "" ""];
      };

      bluetooth = {
        format-disabled = "";
        format-off = "";
        interval = 30;
        on-click = "blueman-manager";
      };

      clock = {
        timezone = "America/Indiana/Indianapolis";
        format = "{:%I:%M}";
        format-alt = "{:%Y-%m-%d %I:%M}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      cpu = {
        format = "󰻠 {usage}% ";
        on-click = "alacritty -e btm";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}% ";
        path = "/";
        on-click = "alacritty -e btm";
      };

      memory = {
        format = "󰍛 {}% ";
        on-click = "alacritty -e btm";
      };

      network = {
        format = "{ifname}";
        format-wifi = "  {signalStrength}%";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "Not connected"; #An empty format will hide the module.
        tooltip-format = " {ifname} via {gwaddri}";
        tooltip-format-wifi = " {essid} ({signalStrength}%)";
        tooltip-format-ethernet = "󰈀 {ifname} ({ipaddr}/{cidr})";
        tooltip-format-disconnected = "Disconnected";
        max-length = 50;
        on-click = "alacritty -e nmtui";
      };

      pulseaudio = {
        scroll-step = -1; # %, can be a float
        format = "{icon} {volume}%";
        format-bluetooth = "{volume}% {icon} {format_source}";
        format-bluetooth-muted = " {icon} {format_source}";
        format-muted = " {format_source}";
        format-source = "{volume}% ";
        format-source-muted = "";
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" " " " "];
        };
        on-click = "pavucontrol";
      };
    };
  };

  # style = builtins.readFile ./waybar.css;
  style = ''
    #custom-logo {
      font-weight: bold;
      font-size: 20px;
      color: ${config.lib.stylix.colors.withHashtag.base0D};
    }
  '';

  # systemd.enable = true;
}
