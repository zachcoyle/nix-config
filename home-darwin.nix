{ pkgs, ... }:
{
  home.file = {
    "Library/Application\ Support/neovide/neovide-settings.json".text = import ./users/zcoyle/by-app/neovide.nix;
    ".config/borders/bordersrc".executable = true;
    ".config/borders/bordersrc".text = ''
      #!/bin/bash

      options=(
          style=round
          width=6.0
          hidpi=on
          active_color=0xffebdbb2
          inactive_color=0xff282828
          background_color=0x302c2e34
          blur_radius=25
      )

      borders "''${options[@]}"
    '';
  };

  packages = with pkgs; [ karabiner-elements ];

  programs = {
    firefox.package = pkgs.firefox-bin;
  };
}
