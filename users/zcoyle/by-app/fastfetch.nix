{pkgs, ...}: {
  home.packages = with pkgs; [fastfetch];

  xdg.configFile."fastfetch/config.jsonc".text = builtins.toJSON {
    "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";
    logo = {
      type = "kitty-direct";
      # source = "/home/zcoyle/Developer/github.com/zachcoyle/nix-config/theme/nix-snowflake-colours-gruvbox.png";
      source = "${../../../theme/nix-snowflake-colours-gruvbox.png}";
      width = 30;
      height = 14;
    };
    modules = [
      "title"
      "separator"
      "os"
      "host"
      "kernel"
      "uptime"
      "shell"
      "display"
      "de"
      "wm"
      "wmtheme"
      "theme"
      "icons"
      "font"
      "cursor"
      {
        type = "terminal";
        format = "👻";
      }
      "terminalfont"
      "cpu"
      "gpu"
      "memory"
      "swap"
      "disk"
      "locale"
      "break"
      "colors"
    ];
  };
}
