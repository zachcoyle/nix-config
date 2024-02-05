{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sword-flake.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
    (_: prev: {
      inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide;
    })
  ];
}
