{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.nixpkgs-firefox-darwin.overlay
    (_: prev: {
      inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide;
    })
  ];
}
