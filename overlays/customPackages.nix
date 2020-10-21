self: super:

{
  mas = super.callPackage ../pkgs/mas/default.nix { };
  segno = super.callPackage ../pkgs/segno_pkg/default.nix { };
  airdrop-cli = super.callPackage ../pkgs/airdrop-cli/default.nix { };
  xcodeproj = super.callPackage ../pkgs/xcodeproj/default.nix { };
}
