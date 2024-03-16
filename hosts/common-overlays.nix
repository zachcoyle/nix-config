{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    inputs.neovim.overlay
    inputs.nixneovimplugins.overlays.default
    (_: prev: {
      sg-nvim = inputs.sg-nvim.legacyPackages.${prev.system}.sg-nvimsg-nvim;
      yofi = inputs.yofi.packages.${prev.system}.default;
      inherit (inputs.zls.packages.${prev.system}) zls;
      inherit (inputs.nixfmt.packages.${prev.system}) nixfmt;
      ezra-sil = prev.callPackage ../packages/fonts/ezra-sil.nix {};
      galatia-sil = prev.callPackage ../packages/fonts/galatia-sil.nix {};
    })
  ];
}
