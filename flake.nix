{
  description = "";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgsMaster.url = "github:nixos/nixpkgs/master";
    nur.url = "github:nix-community/NUR";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-utils.url = "github:numtide/flake-utils";

    alacritty-ligature = { url = "github:zenixls2/alacritty/ligature"; flake = false; };
    devshell.url = "github:numtide/devshell";
    nyxt.url = "github:atlas-engineer/nyxt";

    neovim.url = "github:vi-tality/neovitality";

    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    scrollbar-nvim = { url = "github:Xuyuanp/scrollbar.nvim"; flake = false; };
    vim-dadbod-ui = { url = "github:kristijanhusak/vim-dadbod-ui"; flake = false; };
    vim-prisma = { url = "github:pantharshit00/vim-prisma"; flake = false; };
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , nixpkgsMaster
    , flake-utils
    , nur
    , home-manager
    , devshell
    , ...
    }@inputs:
    let
      packagesOverlay = system: final: prev: {
        bleedingEdge = nixpkgsMaster.legacyPackages."${system}";
        fzf = nixpkgsMaster.legacyPackages."${system}".fzf;
        zsh-powerlevel10k = nixpkgsMaster.legacyPackages."${system}".zsh-powerlevel10k;
        nyxt = inputs.nyxt.defaultPackage."${system}";
        neovim = inputs.neovim.defaultPackage."${system}";
        alacritty = nixpkgs.legacyPackages."${system}".alacritty.overrideAttrs (oldAttrs: rec {
          src = inputs.alacritty-ligature;
          name = "alacritty";
          cargoDeps = oldAttrs.cargoDeps.overrideAttrs (nixpkgs.lib.const {
            name = "${name}-vendor.tar.gz";
            inherit src;
            outputHash = "t6G7kjXoOIc0BmCSRYHOr4kzTQGIlsLy7eJuhlqSSvE=";
          });
        });
      };

      overlays = system: [
        nur.overlay
        devshell.overlay
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
