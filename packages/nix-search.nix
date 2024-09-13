{pkgs, ...}:
pkgs.writeShellApplication {
  name = "ns";
  runtimeInputs = with pkgs; [
    fzf
    rippkgs
  ];
  text = ''
    : | fzf --bind 'start:reload:rippkgs || true' \
        --bind 'change:reload:rippkgs {q} || true'
  '';
}
