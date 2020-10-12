{ home
, config
, ...
}:

{
  home.file.".config/alacritty/alacritty.yml".text =
    builtins.readFile ./dotfiles/alacritty.yml;

  home.file."Library/Application Support/iTerm2/DynamicProfiles/Profiles.json".text =
    builtins.readFile ./dotfiles/iterm2/Profiles.json;

  home.file."Library/Application Support/VSCodium/User/settings.json".text = ''
    {
      "update": {
        "mode": "none"
      },
      "vscode-neovim.neovimPath": "${config.programs.neovim.finalPackage}/bin/nvim",
      "editor.formatOnSave": true,
      "editor.lineNumbers": "relative"
      "editor.cursorStyle": "block",
      "editor.fontLigatures": true,
      "editor.fontFamily": "FiraCode Nerd Font",
    }
  '';
}
