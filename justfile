host := `hostname -s`
user := `whoami`
configurationTypeForOS := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }
darwinRebuildCommand := "darwin-rebuild switch --flake . --show-trace |& nom"
nixosRebuildCommand := "nh os switch ."
rebuildCommand := if os() == "macos" { darwinRebuildCommand } else { nixosRebuildCommand }

default:
    just -l

fmt:
    nix fmt

switch:
    git add .
    {{ rebuildCommand }}

alias s := switch

# workaround for the build user issue w/sequoia for now
sequoia:
    darwin-rebuild switch --flake . --option build-users-group '' |& nom

check:
    nix flake check

alias c := check

cachix-nixos:
    nix build -L .#nixosConfigurations.{{ host }}.config.system.build.toplevel --json \
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

iso:
    nix build -L .#nixosConfigurations.iso.config.system.build.isoImage

iso-t2:
    nix build -L .#nixosConfigurations.iso-t2.config.system.build.isoImage
