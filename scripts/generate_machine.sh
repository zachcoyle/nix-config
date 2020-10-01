# https://www.reddit.com/r/NixOS/comments/ae9q01/how_to_os_from_inside_a_nix_file/ednqzap/
# also consider builtins.currentSystem
echo "{ hostname = \"$(hostname)\"; operatingSystem = \"$(uname -v | awk '{ print $1 }' | sed 's/#.*-//')\"; }" >~/.config/nixpkgs/machine.nix
