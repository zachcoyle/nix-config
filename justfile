host := `hostname -s`
user := `whoami`
configurationTypeForOS := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }
nixosRebuildCommand := if os() == "macos" { "darwin-rebuild" } else { "sudo nixos-rebuild" }

# just -l
default:
  just -l

# formats repo
fmt:
  nix fmt

# builds config
build:
  nix build .#{{configurationTypeForOS}}.{{host}}.system
alias b := build

# Build configuration for current host and switch 
switch:
  {{ nixosRebuildCommand }} switch --flake .
alias s := switch

# Updates the lockfile entry for INPUT and commmits
update INPUT:
  nix flake lock --update-input {{INPUT}} --commit-lock-file
alias u := update

# Updates module inputs on separate commits aka things less likely to break stuff lol
update_modules:
  just u home-manager
  just u nix-dariwin
  just u nix-doom-emacs
  just u nixvim
  just u pre-commit-hooks
  just u flake-utils
  just u nix-vscode-extensions

# Update all inputs
update_all:
  nix flake lock --recreate-lock-file --commit-lock-file

#enableDeveloperMode:
#  sudo /usr/sbin/DevToolsSecurity --enable
#  sudo dscl . append /Groups/_developer GroupMembership {{user}}
