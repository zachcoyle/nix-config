{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    inputs.rippkgs.overlays.default
    inputs.neovim-plugins-nightly-overlay.overlays.default
    (_: prev: {
      sg-nvim = inputs.sg-nvim.legacyPackages.${prev.system}.sg-nvimsg-nvim;
      inherit (inputs.zls.packages.${prev.system}) zls;
      ezra-sil = prev.callPackage ../packages/fonts/ezra-sil.nix {};
      galatia-sil = prev.callPackage ../packages/fonts/galatia-sil.nix {};
      cheltenham-condensed-bold = prev.callPackage ../packages/fonts/cheltenham-condensed-bold/package.nix {};
    })
  ];
}
