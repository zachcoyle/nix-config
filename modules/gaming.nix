{ pkgs, pkgsStable, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
  };

  nixpkgs.config.allowUnfreePredicate = import ../unfreePredicate.nix;

  home-manager.users.zcoyle.home.packages = with pkgs; [
    discord
    dwarf-fortress-packages.dwarf-fortress-full
    pkgsStable.heroic
    retroarchFull
  ];
}
