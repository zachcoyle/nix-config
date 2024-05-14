{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hypridle.overlays.default
    inputs.hyprlock.overlays.default
    inputs.hyprpicker.overlays.default
    inputs.hyprland.overlays.default
    (_: prev: {
      pyprland = inputs.pyprland.packages.${prev.system}.default;
      ags = inputs.ags.packages.${prev.system}.default;
    })
  ];
}
