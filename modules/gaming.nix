{ pkgs, lib, ... }:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (lib.getName pkg) [
      "dwarf-fortress"
      "steam"
      "steam-original"
      "steam-run"
    ];

  home-manager.users.zcoyle.home.packages = with pkgs; [
    discord
    dwarf-fortress-packages.dwarf-fortress-full
    heroic
    opendune
    openloco
  ];
}
