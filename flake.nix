{
  description = "";

  inputs = rec {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgsMaster.url = "github:nixos/nixpkgs/master";
    flake-utils.url = "github:numtide/flake-utils";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nur.url = "github:nix-community/NUR";
    devshell.url = "github:numtide/devshell";

    galaxyline-nvim = { url = "github:glepnir/galaxyline.nvim"; flake = false; };
    scrollbar-nvim = { url = "github:Xuyuanp/scrollbar.nvim"; flake = false; };
    vim-dadbod-ui = { url = "github:kristijanhusak/vim-dadbod-ui"; flake = false; };
    vim-prisma = { url = "github:pantharshit00/vim-prisma"; flake = false; };

    rnix-lsp.url = "github:elkowar/rnix-lsp";

    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self
    , darwin
    , nixpkgs
    , nixpkgsMaster
    , flake-utils
    , nur
    , home-manager
    , neovim-nightly-overlay
    , devshell
    , ...
    }@inputs:
    let
      overlays = [
        neovim-nightly-overlay.overlay
        nur.overlay
        devshell.overlay
        (final: prev: {
          bleedingEdge = nixpkgsMaster.legacyPackages.x86_64-darwin;
          fzf = nixpkgsMaster.legacyPackages.x86_64-darwin.fzf;
          zsh-powerlevel10k = nixpkgsMaster.legacyPackages.x86_64-darwin.zsh-powerlevel10k;
          rnix-lsp = inputs.rnix-lsp.defaultPackage;
        })
        (final: prev:
          let
            inherit (prev.vimUtils) buildVimPluginFrom2Nix;
          in
          {
            myVimPlugins = {
              galaxyline-nvim = buildVimPluginFrom2Nix {
                pname = "galaxyline-nvim";
                version = "master";
                src = inputs.galaxyline-nvim;
              };
              scrollbar-nvim = buildVimPluginFrom2Nix {
                pname = "scrollbar-nvim";
                version = "master";
                src = inputs.scrollbar-nvim;
              };
              vim-dadbod-ui = buildVimPluginFrom2Nix {
                pname = "vim-dadbod-ui";
                version = "master";
                src = inputs.vim-dadbod-ui;
              };
              vim-prisma = buildVimPluginFrom2Nix {
                pname = "vim-prisma";
                version = "master";
                src = inputs.vim-prisma;
              };
            };
          })
      ];
    in
    {
      darwinConfigurations."Zachs-Macbook-Pro" = darwin.lib.darwinSystem {
        modules = [
          ./darwin-configuration.nix
          { nixpkgs.overlays = overlays; }
        ];
      };

      homeConfigurations = {
        homeConfig = home-manager.lib.homeManagerConfiguration {
          configuration = { pkgs, ... }: {
            nixpkgs.overlays = overlays;
            imports = [ ./home.nix ];
          };
          system = "x86_64-darwin";
          homeDirectory = "/Users/zcoyle";
          username = "zcoyle";
        };
      };

      homeConfig = self.homeConfigurations.homeConfig.activationPackage;
    };
}
