{ pkgs ? import <nixpkgs> { } }:
let
  system = pkgs.system;
  flake = builtins.getFlake (toString ./.);
in
{
  inherit flake builtins;
  lib = flake.inputs.nixpkgs.lib;
  pkgs = flake.inputs.nixpkgs.legacyPackages.${system};
}
