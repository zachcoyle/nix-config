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

  home.file = with builtins; {
    ".config/alacritty/alacritty.yml".text = readFile ./dotfiles/alacritty.yml;
    "Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".text = readFile ./dotfiles/iterm2/Profiles.json;
    "Library/Application Support/VSCodium/User/settings.json".text = toJSON vscodeSettings;
    "Library/Application Support/Code/User/settings.json".text = toJSON vscodeSettings;
  };

}
