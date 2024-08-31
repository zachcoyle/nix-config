{
  lib,
  config,
  ...
}:
let
  leader = "ctrl+space";

  sequence = keyseq: builtins.concatStringsSep ">" keyseq;

  ghostty_config = {
    background-opacity = 0.8;
    background-blur-radius = 20;
    cursor-style = "block";
    adjust-underline-position = 20;
    font-family = config.stylix.fonts.monospace.name;
    font-size = config.stylix.fonts.sizes.terminal;
    gtk-titlebar = "false";
    theme = "GruvboxDark";
    window-padding-balance = "true";
    window-padding-color = "extend";
    window-padding-x = 4;
    window-padding-y = 0;
    mouse-hide-while-typing = "true";
    custom-shader-animation = "true";
    font-feature = [
      "calt"
      "ss01"
      "ss02"
      "ss03"
      "ss04"
      "ss05"
      "ss06"
      "ss07"
      "ss08"
      "ss09"
      "liga"
    ];
    # custom-shader = [ ];
    keybind = [
      "ctrl+shift+c=copy_to_clipboard"
      "ctrl+shift+v=paste_from_clipboard"
      "super+c=copy_to_clipboard"
      "super+r=reload_config"
      "super+v=paste_from_clipboard"
      (
        (sequence [
          leader
          "h"
        ])
        + "=goto_split:left"
      )
      (
        (sequence [
          leader
          "j"
        ])
        + "=goto_split:bottom"
      )
      (
        (sequence [
          leader
          "k"
        ])
        + "=goto_split:top"
      )
      (
        (sequence [
          leader
          "l"
        ])
        + "=goto_split:right"
      )
      (
        (sequence [
          leader
          "n"
          "j"
        ])
        + "=new_split:down"
      )
      (
        (sequence [
          leader
          "n"
          "l"
        ])
        + "=new_split:right"
      )
    ];
  };
in
{
  home.file.".config/ghostty/config".text = builtins.concatStringsSep "\n" (
    lib.mapAttrsToList (
      name: value:
      if name == "palette" then
        (builtins.concatStringsSep "\n" (builtins.map (x: "palette = ${x}") value))
      else if name == "font-feature" then
        (builtins.concatStringsSep "\n" (builtins.map (x: "font-feature = ${x}") value))
      else if name == "keybind" then
        (builtins.concatStringsSep "\n" (builtins.map (x: "keybind = ${x}") value))
      else if name == "custom-shader" then
        (builtins.concatStringsSep "\n" (builtins.map (x: "custom-shader = ${x}") value))
      else
        "${name} = ${builtins.toString value}"
    ) ghostty_config
  );
}
