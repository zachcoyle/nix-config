{
  pkgs,
  lib,
  std,
  config,
  ...
}: let
  inherit (config.lib.formats.rasi) mkLiteral;
  inherit (config.lib.stylix) colors;

  rgba = {
    color,
    alpha,
  }: let
    channel = c: builtins.toString (builtins.floor ((std.num.parseFloat colors."${color}-dec-${c}") * 255));
  in "rgba(${channel "r"}, ${channel "g"}, ${channel "b"}, ${builtins.toString alpha}%)";

  # backgrounds
  base00_100 = rgba {
    color = "base00";
    alpha = 100;
  };
  base00_80 = rgba {
    color = "base00";
    alpha = 80;
  };
  # foregrounds
  base07_100 = rgba {
    color = "base07";
    alpha = 100;
  };
  base07_80 = rgba {
    color = "base07";
    alpha = 80;
  };
  base07_20 = rgba {
    color = "base07";
    alpha = 20;
  };
  # colors
  base08_80 = rgba {
    color = "base08";
    alpha = 80;
  };
  base0D_100 = rgba {
    color = "base0D";
    alpha = 100;
  };
  base0D_80 = rgba {
    color = "base0D";
    alpha = 100;
  };

  clear = mkLiteral "rgba(0,0,0,0%)";
  active_bg = mkLiteral base07_80;
  bg = mkLiteral base00_80;
  blue = mkLiteral base0D_80;
  border = mkLiteral base0D_100;
  fg = mkLiteral base07_100;
  red = mkLiteral base08_80;
  selected_bg = mkLiteral base07_20;
  text = mkLiteral base07_100;
  selected_text = mkLiteral base00_100;
in {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    terminal = lib.getExe pkgs.alacritty;
    plugins = with pkgs; [
      rofi-calc
      rofi-emoji-wayland
    ];
    pass = {
      enable = true;
      package = pkgs.rofi-pass-wayland;
      stores = [
        # TODO:
        "/home/zcoyle/Passwords"
      ];
    };
    theme = {
      element-icon = {
        size = mkLiteral "32px";
        padding = mkLiteral "10px";
      };
      element-text = {
        vertical-align = mkLiteral "0.5";
        padding = mkLiteral "10px";
        text-color = text;
      };
      "element.selected" = {
        text-color = selected_text;
      };
      "*" = {
        active-background = active_bg;
        active-foreground = fg;
        alternate-active-background = clear;
        alternate-active-foreground = mkLiteral "@active-foreground";
        alternate-normal-background = clear;
        alternate-normal-foreground = mkLiteral "@foreground";
        alternate-urgent-background = clear;
        alternate-urgent-foreground = mkLiteral "@urgent-foreground";
        background = bg;
        background-color = clear;
        border-color = border;
        bordercolor = border;
        font = "Fira Sans 14";
        foreground = fg;
        inherit blue;
        inherit red;
        lightbg = mkLiteral "rgba(238,232,213,80%)";
        lightfg = mkLiteral "rgba(88,104,117,80%)";
        normal-background = clear;
        normal-foreground = mkLiteral "@foreground";
        selected-active-background = selected_bg;
        selected-active-foreground = fg;
        selected-normal-background = selected_bg;
        selected-normal-foreground = fg;
        selected-urgent-background = selected_bg;
        selected-urgent-foreground = fg;
        separatorcolor = border;
        spacing = 2;
        # text-color = text;
        urgent-background = mkLiteral "rgba(0,43,55,80%)";
        urgent-foreground = fg;
      };
      window = {
        background-color = mkLiteral "@background";
        border = 1;
        border-radius = 10;
        padding = 0;
      };
      mainbox = {
        border = 0;
        padding = 0;
      };
      message = {
        border = mkLiteral "1px solid 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        padding = mkLiteral "1px";
      };
      textbox = {
        text-color = text;
      };
      listview = {
        lines = 12;
        fixed-height = 0;
        border = mkLiteral "1px solid 0px 0px";
        border-color = mkLiteral "@separatorcolor";
        spacing = mkLiteral "2px";
        scrollbar = false;
        padding = mkLiteral "0px 0px 0px";
      };
      element = {
        border = 0;
        padding = mkLiteral "1px";
      };
      "element.normal" = {
        background-color = mkLiteral "@normal-background";
        text-color = text;
      };
      "element.selected.normal" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = text;
      };
      "element.selected.urgent" = {
        background-color = mkLiteral "@selected-urgent-background";
        text-color = text;
      };
      "element.selected.active" = {
        background-color = mkLiteral "@selected-active-background";
        text-color = text;
      };
      "element.alternate.normal" = {
        background-color = mkLiteral "@alternate-normal-background";
        text-color = text;
      };
      "element.alternate.urgent" = {
        background-color = mkLiteral "@alternate-urgent-background";
        text-color = text;
      };
      "element.alternate.active" = {
        background-color = mkLiteral "@alternate-active-background";
        text-color = text;
      };
      scrollbar = {
        width = mkLiteral "4px";
        border = 0;
        handle-width = mkLiteral "8px";
        padding = 0;
        background-color = clear;
        foreground-color = fg;
      };
      mode-switcher = {
        border = mkLiteral "2px solid 0px 0px";
        border-color = mkLiteral "@separatorcolor";
      };
      "button.selected" = {
        background-color = mkLiteral "@selected-normal-background";
        text-color = text;
      };
      inputbar = {
        padding = 10;
        spacing = 10;
        text-color = text;
        children = [
          "prompt"
          "textbox-prompt-colon"
          "entry"
          "case-indicator"
        ];
      };
      case-indicator = {
        spacing = 0;
        text-color = mkLiteral "@normal-foreground";
      };
      entry = {
        spacing = 0;
        vertical-align = mkLiteral "0.5";
        text-color = text;
      };
      prompt = {
        font = "Fira Sans 20";
        padding = 10;
        spacing = 12;
        text-color = text;
      };
      textbox-prompt-colon = {
        expand = false;
        str = "";
      };
    };
    extraConfig = {
      "kb-row-up" = "Up,Control+k,Shift+Tab,Shift+ISO_Left_Tab";
      "kb-row-down" = "Down,Control+j";
      "kb-accept-entry" = "Control+m,Return,KP_Enter";
      "kb-remove-to-eol" = "Control+Shift+e";
      "kb-mode-next" = "Shift+Right,Control+Tab,Control+l";
      "kb-mode-previous" = "Shift+Left,Control+Shift+Tab,Control+h";
      "kb-remove-char-back" = "BackSpace";
      "kb-mode-complete" = ""; # default conflicts with Control+l
    };
  };
}
