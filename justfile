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
    {{ nixosRebuildCommand }} switch --flake . --show-trace 

alias s := switch

check:
    nix flake check

alias c := check

cachix-nixos:
    nix build -L .#nixosConfigurations.nixos-laptop.config.system.build.toplevel --json \
      | jq -r '.[].outputs | to_entries[].value' \
      | cachix push zachcoyle

cachix-darwin:
    nix build .#{{ configurationTypeForOS }}.{{ host }}.system --json \
      | jq -r '.[].outputs | to_entries[].value' \
      | cachix push zachcoyle

cachix-inputs:
    nix flake archive --json \
      | jq -r '.path,(.inputs|to_entries[].value.path)' \
      | cachix push zachcoyle

why INPUT:
    nix why-depends .#nixosConfigurations.{{ host }}.config.system.build.toplevel .#nixosConfigurations.{{ host }}.pkgs.{{ INPUT }} --derivation
