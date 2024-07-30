{ pkgs, lib, ... }:
{
  programs.alacritty = {
    enable = true;
    settings = lib.recursiveUpdate {
      window = {
        decorations = "None";
        decorations_theme_variant = "Dark";
        blur = true;
        padding = {
          x = 4;
          y = 0;
        };
      };
      font = {
        # normal.family = "FiraCode Nerd Font";
        # size = 10.0;
      };
      mouse.hide_when_typing = true;
      keyboard.bindings =
        [
          {
            key = "V";
            mods = "Super";
            action = "Paste";
          }
          {
            key = "C";
            mods = "Super";
            action = "Copy";
          }
        ]
        ++ lib.optionals pkgs.stdenv.isDarwin [
          {
            key = "T";
            mods = "Command";
            action = "CreateNewTab";
          }
        ];
    } (if pkgs.stdenv.isDarwin then { window.opacity = lib.mkForce 0.8; } else { });
  };
}
