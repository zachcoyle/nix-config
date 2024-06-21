{ inputs, ... }:
{
  nixpkgs.overlays = [
    inputs.sddm-sugar-candy-nix.overlays.default
    inputs.hypridle.overlays.default
    inputs.hyprlock.overlays.default
    inputs.hyprpicker.overlays.default
    inputs.hyprland.overlays.default
    inputs.neovim-nightly-overlay.overlays.default
    inputs.icon-themes-nightly-overlay.overlays.default
    inputs.xremap-flake.overlays.default
    (_: prev: {
      logos = inputs.logos.packages.${prev.system}.default;
      pyprland = inputs.pyprland.packages.${prev.system}.default;
      ags = inputs.ags.packages.${prev.system}.default;
      quickshell = inputs.quickshell.packages.${prev.system}.default;
      # FIXME: https://github.com/NixOS/nixpkgs/issues/298539
      rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
      rofi-emoji = prev.rofi-emoji.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
    })
  ];
}
