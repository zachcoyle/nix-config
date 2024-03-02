{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hyprland.overlays.default
    inputs.hypridle.overlays.default
    inputs.hyprlock.overlays.default
  ];
}
