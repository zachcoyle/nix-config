{
  description = "";

  inputs = rec {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nur.url = github:nix-community/NUR;

    darwin = {
      url = github:lnl7/nix-darwin/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = github:numtide/flake-utils;

    rust-overlay.url = github:oxalica/rust-overlay;
    emacs-overlay.url = github:nix-community/emacs-overlay;

    alacritty-ligature = { url = github:zenixls2/alacritty/ligature; flake = false; };
    nyxt.url = github:atlas-engineer/nyxt;

    neovim.url = github:vi-tality/neovitality;

  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , flake-utils
    , nur
    , home-manager
    , rust-overlay
    , emacs-overlay
    , ...
    }@inputs:
    let
      packagesOverlay = system: final: prev:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          fzf = pkgs.fzf;
          nyxt = inputs.nyxt.defaultPackage.${system};
          neovim = inputs.neovim.defaultPackage.${system};

          #alacritty = nixpkgs.legacyPackages."${system}".alacritty.overrideAttrs (oldAttrs: rec {
          #  src = inputs.alacritty-ligature;
          #  name = "alacritty";
          #  cargoDeps = oldAttrs.cargoDeps.overrideAttrs (nixpkgs.lib.const {
          #    name = "${name}-vendor.tar.gz";
          #    inherit src;
          #    outputHash = "FC3+9wjk/Samq2T/I/DXzGdV9/8puGI0OlJhG6o3rcg=";
          #  });
          #});

        };

      overlays = system: [
        rust-overlay.overlay
        emacs-overlay.overlay
        nur.overlay
        (packagesOverlay system)
      ];
    in
    rec {
      darwinConfigurations."Zachs-Macbook-Pro" = darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          { nixpkgs.overlays = (overlays "x86_64-darwin"); }
        ];
      };

      homeConfigurations = {
        darwinHomeConfig = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = (overlays "x86_64-darwin");
            imports = [ ./home.nix ];
          };
          system = "x86_64-darwin";
          homeDirectory = "/Users/zcoyle";
          username = "zcoyle";
        };

        linuxHomeConfig = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = (overlays "x86_64-linux");
            imports = [ ./home.nix ];
          };
          system = "x86_64-linux";
          homeDirectory = "/home/zach";
          username = "zach";
        };

      };

      nixosConfigurations.nixbox = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ ./nixos/nixbox/configuration.nix ];
      };

      darwinHomeConfig = self.homeConfigurations.darwinHomeConfig.activationPackage;
      linuxHomeConfig = self.homeConfigurations.linuxHomeConfig.activationPackage;

    };
}
