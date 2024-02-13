{inputs, ...}: {
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hyprland.overlays.default
    (_: prev: {
      ollama = inputs.ollama-flake.packages.${prev.system}.rocm;
    })
  ];
}
