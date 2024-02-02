{pkgs, ...}: {
  enable = pkgs.system == "x86_64-linux";

  settings = {
    mainBar = {
      layer = "top";
      position = "top";
      height = 30;
      margin = "4";

      modules-left = [
        "hyprland/window"
      ];

      modules-center = [
        "tray"
        "hyprland/workspaces"
      ];

      modules-right = [
        "cpu"
        "memory"
        "disk"
        "custom/nixos"
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
        "format-charging" = "󱐋 {capacity}%";
        "format-plugged" = " {capacity}%";
        "format-alt" = "{icon}  {time}";
        # "format-good" = ""; # An empty format will hide the module
        # "format-full" = "";
        "format-icons" = ["" "" "" "" ""];
      };

      bluetooth = {
        "format-disabled" = "";
        "format-off" = "";
        interval = 30;
        "on-click" = "blueman-manager";
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

      "custom/nixos" = {
        format = "󱄅 {}";
        return-type = "json";
        restart-interval = 60;
        on-click = "alacritty -e 'sudo nixos-rebuild switch --flake /home/zcoyle/Developer/github.com/zachcoyle/config'";
        exec = "${pkgs.writeScriptBin "nix-fresh.sh" ''
          threshhold_green=0
          threshhold_yellow=25
          threshhold_red=100
          updates=$(nixos-rebuild dry-build --flake . 2>  >(grep -i "/nix/store" | wc -l))
          css_class="green"
          if [ "$updates" -gt $threshhold_yellow ]; then
              css_class="yellow"
          fi
          if [ "$updates" -gt $threshhold_red ]; then
              css_class="red"
          fi
          if [ "$updates" -gt $threshhold_green ]; then
              printf '{"text": "%s", "alt": "%s", "tooltip": "%s Updates", "class": "%s"}' "$updates" "$updates" "$updates" "$css_class"
          else
              printf '{"text": "0", "alt": "0", "tooltip": "0 Updates", "class": "green"}'
          fi
        ''}/bin/nix-fresh.sh";
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
        format-wifi = " {signalStrength}%";
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
        # "scroll-step"= 1; # %, can be a float
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

      # tray = {
      #   # "icon-size"= 21;
      #   spacing = 10;
      # };
    };
  };

  style = builtins.readFile ./waybar.css;

  systemd.enable = true;
}
