{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    neovim
  ];

  home-manager.backupFileExtension = "backup";

  nix = {
    package = pkgs.nixVersions.latest;
    settings = {
      experimental-features = "nix-command flakes";
      trusted-users = [ "zcoyle" ];
      auto-optimise-store = true;
      use-xdg-base-directories = true;
      download-attempts = 20;
      substituters = [
        "https://crane.cachix.org"
        "https://devenv.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://zachcoyle.cachix.org"
      ];
      trusted-public-keys = [
        "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "zachcoyle.cachix.org-1:Zgr8u70LueWgpbSPM4E8JqxpQcGISxivplq1I9qogGg="
      ];
    };
  };

  fonts = {
    packages = with pkgs; [
      fira
      fira-code-nerdfont
      inter
      noto-fonts
      monaspace
      (nerdfonts.override {
        fonts = [
          "FiraCode"
          "FiraMono"
          "Gohu"
          "HeavyData"
          "Iosevka"
          "IosevkaTerm"
          "IosevkaTermSlab"
          "JetBrainsMono"
          "Lilex"
          "OpenDyslexic"
          # "ShureTechMono"
        ];
      })
      (pkgs.callPackage ./packages/fonts/ezra-sil.nix { })
      (pkgs.callPackage ./packages/fonts/galatia-sil.nix { })
    ];
  } // (if pkgs.stdenv.isLinux then { fontDir.enable = true; } else { });
}
