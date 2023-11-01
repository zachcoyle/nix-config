host := `hostname -s`
configurationTypeForOS := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }

fmt:
  nix fmt

build:
  nix build .#{{configurationTypeForOS}}.{{host}}.system

switch:
  darwin-rebuild switch --flake .

alias u := update
update INPUT:
  nix flake lock --update-input {{INPUT}} --commit-lock-file

update_modules:
  just u home-manager
  just u nixvim
  just u nix-dariwin

update_all:
  nix flake lock --recreate-lock-file --commit-lock-file
