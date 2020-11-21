self: super:
let
  sources = import ../nix/sources.nix;
  nixpkgsMaster = import sources.nixpkgs {
    overlays = [ ];
    config = { };
  };

in
{
  mas = super.callPackage ../pkgs/mas/default.nix { };
  airdrop-cli = super.callPackage ../pkgs/airdrop-cli/default.nix { };
  xcodeproj = super.callPackage ../pkgs/xcodeproj/default.nix { };
  jdtls = super.callPackage ../pkgs/jdtls/default.nix { };
  fzf = nixpkgsMaster.fzf;
  zsh-powerlevel10k = nixpkgsMaster.zsh-powerlevel10k;
}
