{
  description = "Darwin system flake";

  inputs = {
    devshell.url = "github:numtide/devshell";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-utils.url = "github:numtide/flake-utils";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";
    nixpkgs-23-05-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-firefox-darwin.url = "github:bandithedoge/nixpkgs-firefox-darwin";
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixvim.url = "github:nix-community/nixvim";
    nur.url = "github:nix-community/nur";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = inputs:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
        (import ./darwin-flake-module.nix)
      ];
      systems = [
        "x86_64-darwin"
      ];

      perSystem = {
        config,
        pkgs,
        ...
      }: {
        formatter = pkgs.alejandra;

        pre-commit = {
          settings = {
            hooks = {
              # codespell.enable = true;
              alejandra.enable = true;
              deadnix.enable = true;
              nil.enable = true;
              statix.enable = true;
            };
          };
        };

        devshells.default = {
          name = "system flake";
          env = [];
          devshell.startup.pre-commit-hooks.text = ''
            ${config.pre-commit.installationScript}
          '';
          packages = with pkgs; [
            just
            deadnix
            alejandra
            statix
          ];
        };
      };
    };
}
