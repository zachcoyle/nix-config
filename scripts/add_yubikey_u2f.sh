#!/usr/bin/env -S nix shell nixpkgs#pam_u2f --command bash

BASE_DIR="$XDG_CONFIG_HOME/Yubico"
CFG_FILE="$BASE_DIR/u2f_keys"

mkdir -p "$BASE_DIR"

if [ -f "$CFG_FILE" ]; then
    pamu2fcfg  -n >> "$CFG_FILE"
else
    pamu2fcfg > "$CFG_FILE"
fi


