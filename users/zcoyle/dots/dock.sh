dockutil --list | cut -f1 -d$'\t' | while read app; do
    dockutil --remove "$app"
done

dockutil --add /Applications/Utilities/Activity\ Monitor.app
dockutil --add /Applications/Safari.app
dockutil --add /Applications/Messages.app
dockutil --add /Applications/Mail.app
dockutil --add /Applications/Freeform.app
dockutil --add /Applications/Notes.app
# dockutil --add /Users/zcoyle/Applications/Home\ Manager\ Apps/Emacs.app
dockutil --add /Users/zcoyle/Applications/Home\ Manager\ Apps/VSCodium.app
dockutil --add /Applications/Xcode.app
dockutil --add /Users/zcoyle/Applications/Home\ Manager\ Apps/Alacritty.app
dockutil --add '/Applications' --view grid --display folder
dockutil --add '~/Downloads' --view grid --display folder
