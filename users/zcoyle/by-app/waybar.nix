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
        "custom/neofetch"
        "custom/keyboard"
        "custom/neovide"
        "custom/terminal"
        "custom/firefox"
        "custom/ollama"
        "cpu"
        "memory"
        "disk"
        "pulseaudio"
        "bluetooth"
        "network"
        "battery"
        "clock"
        "custom/spacer"
        "tray"
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

      "custom/neofetch" = {
        format = "  ";
        on-click = "alacritty -e ${pkgs.writeScriptBin "pageneofetch.sh" ''
          neofetch | less
        ''}/bin/pageneofetch.sh";
        tooltip = false;
      };

      "custom/keyboard" = {
        format = " 󰌓 ";
        on-click = "tecla& disown";
        tooltip = false;
      };

      "custom/neovide" = {
        format = "  ";
        on-click = "neovide& disown";
        tooltip = false;
      };

      "custom/terminal" = {
        format = "  ";
        on-click = "alacritty& disown";
        tooltip = false;
      };

      "custom/firefox" = {
        format = " 󰈹 ";
        on-click = "firefox& disown";
        tooltip = false;
      };

      "custom/logo" = {
        format = "   ";
        on-click = "wlogout";
        on-right-click = "swaylock";
        tooltip = false;
      };

      "custom/ollama" = {
        format = " 🦙 ";
        on-click = "alacritty -e oterm& disown";
        tooltip = false;
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
        on-click = "alacritty -e btm& disown";
      };

      disk = {
        interval = 30;
        format = "󰋊 {percentage_used}% ";
        path = "/";
        on-click = "alacritty -e btm& disown";
      };

      memory = {
        format = "󰍛 {}% ";
        on-click = "alacritty -e btm& disown";
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

  style = ''
    #custom-neofetch,
    #custom-keyboard,
    #custom-neovide,
    #custom-terminal,
    #custom-firefox,
    #custom-ollama,
    #custom-logo {
      font-weight: bold;
      font-size: 20px;
      color: ${config.lib.stylix.colors.withHashtag.base0D};
    }
  '';
}
