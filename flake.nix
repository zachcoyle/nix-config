{
  description = "Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-23-05-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
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
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    alacritty-theme,
    flake-utils,
    home-manager,
    neovim,
    nix-darwin,
    nix-doom-emacs,
    nixpkgs-23-05-darwin,
    nixvim,
    pre-commit-hooks,
    nix-vscode-extensions,
    ...
  }:
    {
      # Build darwin flake using:
      # $ darwin-rebuild build --flake .#Zacharys-MacBook-Pro
      darwinConfigurations."Zacharys-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        modules = [
          ./darwin.nix
          home-manager.darwinModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.zcoyle = import ./home.nix;
              extraSpecialArgs = {
                inherit nixvim nix-doom-emacs alacritty-theme;
              };
            };
          }
          {
            # Set Git commit hash for darwin-version.
            system.configurationRevision = self.rev or self.dirtyRev or null;
            nixpkgs.config.allowUnfree = true;
            nixpkgs.overlays = [
              neovim.overlay
              nix-vscode-extensions.overlays.default
              (final: prev: {
                # Currently broken on unstable
                inherit (nixpkgs-23-05-darwin.legacyPackages.x86_64-darwin) neovide;
              })
            ];
          }
        ];
      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Zacharys-MacBook-Pro".pkgs;
    }
    // flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      formatter = pkgs.alejandra;

      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            alejandra.enable = true;
            statix.enable = true;
          };
        };
      };

      devShell = pkgs.mkShell {
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    });
}
