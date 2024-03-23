{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hypridle.overlays.default
    inputs.hyprlock.overlays.default
    inputs.hyprland.overlays.default
    (_: prev: {
      pyprland = inputs.pyprland.packages.${prev.system}.default;
    })
  ];
}
