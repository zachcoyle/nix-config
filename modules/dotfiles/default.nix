{ home
, config
, pkgs
, ...
}:
let
  vscodeSettings = {
    "update" = {
      "mode" = "none";
    };
    "editor.cursorStyle" = "block";
    "editor.fontFamily" = "FiraCode Nerd Font";
    "editor.fontLigatures" = true;
    "editor.formatOnSave" = true;
    "editor.lineNumbers" = "relative";
    "telemetry.enableCrashReporter" = false;
    "telemetry.enableTelemetry" = false;
    "vscode-neovim.neovimPath" = "${pkgs.neovim}/bin/nvim";
    "workbench.colorTheme" = "Gruvbox Minor Dark Medium";
  };

in
{
  home.file.".config/alacritty/alacritty.yml".text =
    builtins.readFile ./dotfiles/alacritty.yml;

  home.file.".config/starship/starship.toml".text =
    builtins.readFile ./dotfiles/starship.toml;

  home.file."Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".text =
    builtins.readFile ./dotfiles/iterm2/Profiles.json;

  home.file."Library/Application Support/VSCodium/User/settings.json".text = builtins.toJSON vscodeSettings;
  home.file."Library/Application Support/Code/User/settings.json".text = builtins.toJSON vscodeSettings;
}
