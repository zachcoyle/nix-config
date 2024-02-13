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
    nix build .#{{ configurationTypeForOS }}.{{ host }}.system

alias b := build

# Build configuration for current host and switch
switch:
    git add .
    {{ nixosRebuildCommand }} switch --flake . --show-trace -L

alias s := switch

iso:
    nix build .#nixosConfigurations.live.config.system.build.isoImage

# Updates the lockfile entry for INPUT and commits
update INPUT:
    nix flake lock --update-input {{ INPUT }} --commit-lock-file --show-trace

alias u := update

# Updates module inputs on separate commits aka things less likely to break stuff lol
update_modules:
    just u home-manager
    just u nix-dariwin
    just u nixvim
    just u pre-commit-hooks
    just u flake-utils
    just u nix-vscode-extensions

# Update all inputs
update_all:
    nix flake update --commit-lock-file

collect_garbage:
    sudo nix-collect-garbage -d #> /dev/null 2>&1&

alias gc := collect_garbage

check:
    nix flake check

alias c := check

dock:
  sh ./dock.sh

cachix:
  nix build .#{{ configurationTypeForOS }}.{{ host }}.system --json \
    | jq -r '.[].outputs | to_entries[].value' \
    | cachix push zachcoyle
