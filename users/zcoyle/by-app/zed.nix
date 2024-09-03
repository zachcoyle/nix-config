{
  pkgs,
  lib,
  # config,
  ...
}:
{
  home.packages = with pkgs; [ zed-editor ];
  home.file.".config/zed/settings.json".text = builtins.toJSON {
    vim_mode = true;
    ui_font_size = 14;
    buffer_font_size = 14;
    theme = {
      mode = "system";
      light = "Gruvbox Light";
      dark = "Gruvbox Dark";
    };
    load_direnv = "shell_hook";
    buffer_font_family = "Monaspace Krypton";
    ui_font_family = "Monaspace Krypton";
    ui_font_features = {
      calt = false;
    };
    languages = {
      rust = {
        language_servers = [ "rust-analyzer" ];
      };
    };
    lsp = {
      rust-analyzer = {
        binary = {
          path = "${lib.getExe pkgs.rust-analyzer}";
        };
        initialization_options = {
          checkOnSave = {
            command = "clippy";
          };
        };
      };
    };
    telemetry = {
      diagnostics = false;
      metrics = false;
    };
  };
}
