{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    (_: prev: {
      rustaceanvim = inputs.rustaceanvim.packages.${prev.system}.default;
      sg-nvim = inputs.sg-nvim.legacyPackages.${prev.system}.sg-nvimsg-nvim;
      yofi = inputs.yofi.packages.${prev.system}.default;
    })
  ];
}
