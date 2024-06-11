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

seeya:
    nix run nixpkgs#activate-linux -- -t "SEE YOU SPACE COWBOY..." -b -i -m "" -f "Cheltenham Condensed" -c 1-1-1-1
