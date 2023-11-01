host := `hostname -s`
configurations := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }

fmt:
  nix fmt

build:
  nix build .#{{configurations}}.{{host}}.system

switch:
  darwin-rebuild switch --flake .

alias u := update
update INPUT:
  nix flake lock --update-input {{INPUT}} --commit-lock-file

update_all:
  nix flake lock --recreate-lock-file --commit-lock-file
