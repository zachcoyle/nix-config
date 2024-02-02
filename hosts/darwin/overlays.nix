{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sword-flake.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
  ];
}
