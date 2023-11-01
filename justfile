host := `hostname -s`
user := `whoami`
configurationTypeForOS := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }

fmt:
  nix fmt

build:
  nix build .#{{configurationTypeForOS}}.{{host}}.system

alias s := switch
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

enableDeveloperMode:
  sudo /usr/sbin/DevToolsSecurity --enable
  sudo dscl . append /Groups/_developer GroupMembership {{user}}
