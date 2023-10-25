{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim.url = "github:neovim/neovim?dir=contrib";
    alacritty-theme = {
      url = "github:alacritty/alacritty-theme";
      flake = false;
    };
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = inputs @ {
    self,
    nix-darwin,
    nixpkgs,
    home-manager,
    alacritty-theme,
    nixvim,
    neovim,
    flake-utils,
    pre-commit-hooks,
    ...
  }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Zacharys-MacBook-Pro
      darwinConfigurations."Zacharys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./configuration.nix
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.zcoyle = import ./home.nix;
            home-manager.extraSpecialArgs = {
              inherit alacritty-theme nixvim;
            };
          }
          {
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              neovim.overlay
            ];
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Zacharys-MacBook-Pro".pkgs;

      formatter.x86_64-darwin = nixpkgs.legacyPackages.x86_64-darwin.alejandra;
    }
    // flake-utils.lib.eachDefaultSystem (system: {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
          };
        };
      };
      devShell = nixpkgs.legacyPackages.${system}.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
}
