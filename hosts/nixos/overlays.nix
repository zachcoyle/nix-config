{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hyprland.overlays.default
  ];
}
