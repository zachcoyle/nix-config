{
  description = "";

  inputs = rec {
    nixpkgs.url = github:nixos/nixpkgs/nixpkgs-unstable;
    nix.url = github:nixos/nix;
    flake-utils.url = github:numtide/flake-utils;
    naersk.url = github:nmattia/naersk;
    neovide = { url = github:/Kethku/neovide; flake = false; };
    neovim.url = github:vi-tality/neovitality;
    nur.url = github:nix-community/NUR;
    nyxt.url = github:atlas-engineer/nyxt;
    #alacritty-ligature = { url = github:zenixls2/alacritty/ligature; flake = false; };

    darwin = {
      url = github:lnl7/nix-darwin/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = github:nix-community/home-manager/master;
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , flake-utils
    , nur
    , home-manager
    , ...
    }@inputs:
    let
      packagesOverlay = system: final: prev:
        let
          pkgs = import nixpkgs {
            inherit system;
            nixpkgs.config.allowUnfree = true;
          };
          naersk-lib = inputs.naersk.lib."${system}";
        in
        {
          nyxt = inputs.nyxt.defaultPackage.${system};
          neovim = inputs.neovim.defaultPackage.${system};
          #nixMaster = inputs.nix.defaultPackage.${system};
          neovide = naersk-lib.buildPackage {
            pname = "neovide";
            root = inputs.neovide;
          };

          # alacritty = nixpkgs.legacyPackages."${system}".alacritty.overrideAttrs (oldAttrs: rec {
          #   src = inputs.alacritty-ligature;
          #   name = "alacritty";
          #   cargoDeps = oldAttrs.cargoDeps.overrideAttrs (nixpkgs.lib.const {
          #     name = "${name}-vendor.tar.gz";
          #     inherit src;
          #     outputHash = "FC3+9wjk/Samq2T/I/DXzGdV9/8puGI0OlJhG6o3rcg=";
          #   });
          # });

        };

      overlays = system: [
        nur.overlay
        inputs.nix.overlay
        (packagesOverlay system)
      ];
    in
    rec {
      darwinConfigurations."Zachs-Macbook-Pro" = darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          {
            nixpkgs.overlays = (overlays "x86_64-darwin");
          }
        ];
      };

      homeConfigurations = {
        darwinHomeConfig = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = (overlays "x86_64-darwin");
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.permittedInsecurePackages = [
              "go-1.14.15"
            ];
            imports = [ ./home.nix ];
          };
          system = "x86_64-darwin";
          homeDirectory = "/Users/zcoyle";
          username = "zcoyle";
        };

        linuxHomeConfig = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = (overlays "x86_64-linux");
            nixpkgs.config.allowUnfree = true;
            nixpkgs.config.hardware.opengl.driSupport32Bit = true;
            nixpkgs.config.hardware.pulseAudio.support32Bit = true;
            nixpkgs.config.permittedInsecurePackages = [
              "go-1.14.15"
            ];
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
