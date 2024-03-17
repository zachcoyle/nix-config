{
  pkgs,
  config,
  ...
}: {
  enable = pkgs.stdenv.isLinux;

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;

      modules-left = [
        "custom/logo"
        "hyprland/submap"
        "hyprland/window"
      ];

      modules-center = [
        "hyprland/workspaces"
      ];

      modules-right = [
        "custom/wttrbar"
        "cpu"
        "memory"
        "disk"
        "pulseaudio"
        "bluetooth"
        "battery"
        "clock"
        "custom/spacer"
        "tray"
        "custom/notification"
      ];

      "hyprland/submap" = {
        "format" = "✌🏻 {}";
        "max-length" = 8;
        "tooltip" = false;
      };

      "hyprland/window" = {
        icon = true;
        rewrite = {
          "(.*) — Mozilla Firefox" = "$1";
        };
      };

      "custom/wttrbar" = {
        format = "{}°";
        tooltip = true;
        interval = 600;
        exec = "wttrbar --ampm --location 'Hartford City' --main-indicator temp_F --fahrenheit --custom-indicator '{ICON} {temp_F}'";
        return-type = "json";
      };

      "custom/logo" = {
        format = "   ";
        on-click = "wlogout";
        on-right-click = "hyprlock";
        tooltip = false;
      };

      "custom/spacer" = {
        format = " ";
      };

      "custom/notification" = {
        tooltip = false;
        format = "{icon}";
        format-icons = {
          notification = "<span foreground='red'><sup></sup></span>";
          none = "";
          dnd-notification = "<span foreground='red'><sup></sup></span>";
          dnd-none = "";
          inhibited-notification = "<span foreground='red'><sup></sup></span>";
          inhibited-none = "";
          dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
          dnd-inhibited-none = "";
        };
        return-type = "json";
        exec-if = "which swaync-client";
        exec = "swaync-client -swb";
        on-click = "swaync-client -t -sw";
        on-click-right = "swaync-client -d -sw";
        escape = true;
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
        on-click = "alacritty -e btop& disown";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}% ";
        path = "/";
        on-click = "alacritty -e btop& disown";
      };

      memory = {
        format = "󰍛 {}% ";
        on-click = "alacritty -e btop& disown";
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

  style = ''
    #custom-logo {
      font-weight: bold;
      font-size: 20px;
      color: ${config.lib.stylix.colors.withHashtag.base0D};
    }
  '';
}
