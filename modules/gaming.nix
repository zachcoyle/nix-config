{
  pkgs,
  pkgsStable,
  lib,
  ...
}:
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    extraCompatPackages = [ pkgs.proton-ge-bin ];
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
    pkgsStable.dwarf-fortress-packages.dwarf-fortress-full
    pkgsStable.heroic
    retroarchFull
  ];
}
