{pkgs, ...}: let
  fonts = with pkgs; [
    #fira
    fira-code-nerdfont
    #nerdfonts
  ];
in {
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  nix = {
    package = pkgs.nix;
    gc =
      {
        automatic = true;
        options = "-d";
      }
      // (
        if pkgs.system == "x86_64-linux"
        then {dates = "weekly";}
        else {interval.Weekday = 0;}
      );
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["zcoyle"];
      auto-optimise-store = true;
      substituters = [
        "https://zachcoyle.cachix.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "zachcoyle.cachix.org-1:Zgr8u70LueWgpbSPM4E8JqxpQcGISxivplq1I9qogGg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };

  fonts =
    {
      fontDir.enable = true;
    }
    // (
      if pkgs.system == "x86_64-linux"
      then {packages = fonts;}
      else {inherit fonts;}
    );
}
