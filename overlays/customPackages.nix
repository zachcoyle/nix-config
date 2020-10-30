self: super:

{
  mas = super.callPackage ../pkgs/mas/default.nix { };
  airdrop-cli = super.callPackage ../pkgs/airdrop-cli/default.nix { };
  xcodeproj = super.callPackage ../pkgs/xcodeproj/default.nix { };
}
