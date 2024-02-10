{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.telescope-just.overlays.default
    inputs.nix-vscode-extensions.overlays.default
    inputs.nur.overlay
    inputs.rustaceanvim.overlays.default
    inputs.nixneovimplugins.overlays.default
    (_: prev: {
      sg-nvim = inputs.sg-nvim.legacyPackages.${prev.system}.sg-nvimsg-nvim;
      yofi = inputs.yofi.packages.${prev.system}.default;
      pkgs.vimPlugins.cmp-ai = prev.vimUtils.buildVimPluginFrom2Nix {
        pname = "cmp-ai";
        version = "unstable";
        src = inputs.cmp-ai-src;
      };
    })
  ];
}
