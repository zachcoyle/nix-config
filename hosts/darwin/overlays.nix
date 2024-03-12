{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sword-flake.overlays.default
    inputs.nixpkgs-firefox-darwin.overlay
    (_: prev: {
      inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide;
      borders = prev.stdenv.mkDerivation {
        pname = "borders";
        version = "unstable";
        src = inputs.jankyborders;
        buildInputs = with prev.darwin.apple_sdk.frameworks; [
          AppKit
          CoreVideo
          SkyLight
        ];
      };
    })
  ];
}
