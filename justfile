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
    {{ nixosRebuildCommand }} switch --flake . --show-trace |& nom

alias s := switch

t2iso:
    nix build .#nixosConfigurations.live-t2.config.system.build.isoImage

iso:
    nix build .#nixosConfigurations.live-non-t2.config.system.build.isoImage

collect_garbage:
    sudo nix-collect-garbage -d #> /dev/null 2>&1&

alias gc := collect_garbage

check:
    nix flake check

alias c := check

dock:
    sh ./users/zcoyle/dots/dock.sh

cachix-nixos:
    nix build -L .#nixosConfigurations.nixos-laptop.config.system.build.toplevel --json \
      | jq -r '.[].outputs | to_entries[].value' \
      | cachix push zachcoyle

cachix-darwin:
    nix build .#{{ configurationTypeForOS }}.{{ host }}.system --json \
      | jq -r '.[].outputs | to_entries[].value' \
      | cachix push zachcoyle

why INPUT:
    nix why-depends .#nixosConfigurations.{{ host }}.config.system.build.toplevel .#nixosConfigurations.{{ host }}.pkgs.{{ INPUT }} --derivation

eww:
    pkill -9 eww ; \
    eww daemon -c ./users/zcoyle/by-app/eww && \
    eww open topbar
