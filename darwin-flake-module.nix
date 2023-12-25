{
  self,
  inputs,
  ...
}: let
  common_darwin_config = {
    modules = [
      ./common-system.nix
      ./darwin.nix
      inputs.darwin-modules.darwinModule
      inputs.home-manager.darwinModules.home-manager
      {
        system.configurationRevision = self.rev or self.dirtyRef or null;
        nixpkgs.config.allowUnfree = true;
        nixpkgs.overlays = [
          # FIXME: Not the best place for these overlays to live
          # inputs.neovim-nightly-overlay.overlay
          inputs.telescope-just.overlays.default
          inputs.sword-flake.overlays.default
          inputs.nixpkgs-firefox-darwin.overlay
          inputs.nix-vscode-extensions.overlays.default
          inputs.nur.overlay
          (_: _: {
            # Currently broken on unstable
            rustaceanvim = inputs.rustaceanvim.packages.x86_64-darwin.default;
            sg-nvim = inputs.sg-nvim.legacyPackages.x86_64-darwin.sg-nvimsg-nvim;
            inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.x86_64-darwin) neovide;
          })
        ];
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          users.zcoyle = import ./home.nix;
          extraSpecialArgs = {
            inherit (inputs) nixvim nix-doom-emacs;
          };
        };
      }
    ];
  };
in {
  flake = rec {
    darwinConfigurations = {
      Zachs-MacBook-Pro = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
      Zacharys-MacBook-Pro = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
    };
    darwinPackages = darwinConfigurations."Zacharys-MacBook-Pro".pkgs;
  };
}
