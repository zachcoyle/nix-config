{pkgs, ...}: let
  fonts = with pkgs; [
    fira
    fira-code-nerdfont
    noto-fonts
    ezra-sil
    galatia-sil
    nerdfonts
  ];
in {
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  nix = {
    package = pkgs.nix;
    gc =
      if pkgs.stdenv.isDarwin
      then {
        automatic = true;
        options = "--delete-older-than 7d";
        interval.Weekday = 0;
      }
      else null;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = ["zcoyle"];
      auto-optimise-store = true;
      substituters = [
        "https://zachcoyle.cachix.org"
        "https://nix-community.cachix.org"
        "https://hyprland.cachix.org"
        "https://devenv.cachix.org"
        "https://crane.cachix.org"
      ];
      trusted-public-keys = [
        "zachcoyle.cachix.org-1:Zgr8u70LueWgpbSPM4E8JqxpQcGISxivplq1I9qogGg="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
      ];
    };
  };

  fonts =
    {
      fontDir.enable = true;
    }
    // (
      if pkgs.stdenv.isLinux
      then {packages = fonts;}
      else {inherit fonts;}
    );
}
