{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    (_: _: {
      rustaceanvim = inputs.rustaceanvim.packages.x86_64-linux.default;
      sg-nvim = inputs.sg-nvim.legacyPackages.x86_64-linux.sg-nvimsg-nvim;
    })
  ];
}
