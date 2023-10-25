{
  config,
  pkgs,
  ...
}: {
  home.username = "zcoyle";

  home.stateVersion = "23.05";

  home.packages = with pkgs; [
    neovim
    python3
    poetry
    alacritty
    nodejs_20
    nodePackages_latest.pnpm
    podman
    podman-tui
    qemu
    swift-format
    alejandra
    jq
  ];
}
