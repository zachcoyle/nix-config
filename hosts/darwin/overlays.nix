{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sword-flake.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
    (_: prev: {
      inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide;
<<<<<<< HEAD
=======
      # FIXME: this is in nixpkgs now. delete.
      jankyborders = prev.darwin.apple_sdk_11_0.callPackage ../../packages/jankyborders.nix {
        inherit (prev.darwin.apple_sdk_11_0.frameworks) AppKit CoreGraphics CoreVideo SkyLight;
      };
      sbarlua = prev.darwin.apple_sdk_11_0.callPackage ../../packages/sbarlua.nix {
        src = inputs.sbarlua;
      };
>>>>>>> 523f234 (add sbarlua)
    })
  ];
}
