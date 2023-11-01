fmt:
  nix fmt

switch:
  darwin-rebuild switch --flake .

update:
  nix flake lock --recreate-lock-file --commit-lock-file
