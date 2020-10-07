self: super:

{
  mas = super.callPackage ../pkgs/mas/default.nix { };
  segno = super.callPackage ../pkgs/segno_pkg/default.nix { };
}
