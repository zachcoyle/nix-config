{
  pkgs,
  lib,
  config,
  ...
}:
let
  # TODO:
  # need to come back to this to make it more general
  # I'd had a nice generalized solution thought out but I
  # was having issues with mkLiteral and interpolated strings
  # and just gave up in the meantime for a hard-coded theme until
  # I have some time to clean this up
  inherit (config.lib.formats.rasi) mkLiteral;
  # inherit (config.lib.stylix) colors;
  # inherit (config.lib.stylix.colors) withHashtag;

  # backgrounds
  base00_100 = "rgba(29,32,33,100%)";
  base00_80 = "rgba(29,32,33,60%)";
  base01_100 = "rgba(60,56,54,100%)";
  base01_80 = "rgba(60,56,54,80%)";
  base02_100 = "rgba(80,73,69,100%)";
  base02_80 = "rgba(80,73,69,80%)";
  base03_100 = "rgba(102,92,84,100%)";
  base03_80 = "rgba(102,92,84,80%)";
  # foregrounds
  base04_100 = "rgba(189,174,147,100%)";
  base04_80 = "rgba(189,174,147,80%)";
  base05_100 = "rgba(213,196,161,100%)";
  base05_80 = "rgba(213,196,161,80%)";
  base06_100 = "rgba(235,219,178,100%)";
  base06_80 = "rgba(235,219,178,80%)";
  base07_100 = "rgba(251,241,199,100%)";
  base07_80 = "rgba(251,241,199,80%)";
  base07_20 = "rgba(251,241,199,20%)";
  # colors
  base08_100 = "rgba(251,73,52,100%)";
  base08_80 = "rgba(251,73,52,80%)";
  base09_100 = "rgba(254,128,25,100%)";
  base09_80 = "rgba(254,128,25,80%)";
  base0A_100 = "rgba(250,189,47,100%)";
  base0A_80 = "rgba(250,189,47,80%)";
  base0B_100 = "rgba(184,187,38,100%)";
  base0B_80 = "rgba(184,187,38,80%)";
  base0C_100 = "rgba(142,192,124,100%)";
  base0C_80 = "rgba(142,192,124,80%)";
  base0D_100 = "rgba(131,165,152,100%)";
  base0D_80 = "rgba(131,165,152,50%)";
  base0E_100 = "rgba(211,134,155,100%)";
  base0E_80 = "rgba(211,134,155,80%)";
  base0F_100 = "rgb(214,93,14,100%)";
  base0F_80 = "rgb(214,93,14,80%)";

  clear = mkLiteral "rgba(0,0,0,0%)";
  active_bg = mkLiteral base07_80;
  alt_bg = mkLiteral base00_80;
  bg = mkLiteral base00_80;
  blue = mkLiteral base0D_80;
  border = mkLiteral base0D_100;
  fg = mkLiteral base07_100;
  red = mkLiteral base08_80;
  selected_fg = bg;
  selected_bg = mkLiteral base07_20;
  text = mkLiteral base07_100;
  # text = mkLiteral base07_100;
  selected_text = mkLiteral base00_100;
in
{
  enable = true;
  package = pkgs.rofi-wayland;
  terminal = lib.getExe pkgs.alacritty;
  plugins = with pkgs; [
    rofi-calc
    rofi-emoji
  ];
  theme = {
    # "*" = {
    #   # https://github.com/davatorium/rofi-themes/blob/master/Official%20Themes/solarized_alternate.rasi
    #   alternate-normal-background =  (mkLiteral "rgba( ${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 80%)");
    #   background =  (mkLiteral "rgba( ${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 80%)");
    #   normal-background =  (mkLiteral "rgba( ${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 80%)");
    #   selected-normal-background =  (mkLiteral "rgba( ${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 80%)");
    #   separatorcolor =  (mkLiteral "rgba( ${colors.base00-rgb-r}, ${colors.base00-rgb-g}, ${colors.base00-rgb-b}, 80%)");
    # };
    # prompt = {
    #   text-color =  (mkLiteral "${withHashtag.base06}4F");
    #   padding-horizontal = mkLiteral "10px";
    # };
    # element = {
    #   spacing = mkLiteral "10px";
    #   font = "Fira Sans 12";
    # };
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
    # "element.normal.urgent" = {
    #   background-color = mkLiteral "@urgent-background";
    #   text-color = fg;
    # };
    # "element.normal.active" = {
    #   background-color = mkLiteral "@active-background";
    #   text-color = fg;
    # };
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
}
