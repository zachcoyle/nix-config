{ lib
, pkgs
, programs
, ...
}:
let
  #machine = import ../../machine.nix;
  #isDarwin = machine.operatingSystem == "Darwin";
  isDarwin = true;
  #isNixOS = machine.operatingSystem == "NixOS";
  isNixOS = false;

  #nixosPrograms = import ./nixos.nix;
in
{
  #imports = [ ]
  #  ++ lib.optional isNixOS nixosPrograms
  #  ++ lib.optional isDarwin darwinPrograms;

  programs.home-manager.enable = true;

  programs.htop = {
    enable = true;
  };

  programs.git = {
    enable = true;
    userName = "Zach Coyle";
    userEmail = "zach.coyle@gmail.com";
    package = pkgs.gitAndTools.gitFull;
    delta = { enable = true; };
    extraConfig = {
      pull = { ff = "only"; };
      fetch = { prune = "true"; };
      commit = { gpgsign = "true"; };
    };
  };

  programs.gpg = {
    enable = true;
  };

  programs.jq = {
    enable = true;
  };

}
