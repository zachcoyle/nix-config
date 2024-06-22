{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    inputs.rippkgs.overlays.default
    inputs.neovim-plugins-nightly-overlay.overlays.default
    (_: prev: {
      inherit (inputs.sg-nvim.legacyPackages.${prev.system}) sg-nvim;
      inherit (inputs.zls.packages.${prev.system}) zls;
      ezra-sil = prev.callPackage ../packages/fonts/ezra-sil.nix { };
      galatia-sil = prev.callPackage ../packages/fonts/galatia-sil.nix { };
    })
  ];
}
