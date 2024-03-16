{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sword-flake.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
    (_: prev: {
      inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide;
      # FIXME: this is in nixpkgs now. delete.
      jankyborders = prev.darwin.apple_sdk_11_0.callPackage ../../packages/jankyborders.nix {
        inherit (prev.darwin.apple_sdk_11_0.frameworks) AppKit CoreGraphics CoreVideo SkyLight;
      };
    })
  ];
}
