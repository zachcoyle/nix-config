{
  description = "Darwin system flake";

  inputs = {
    # system
    nixpkgs.url = "github:NixOS/nixpkgs";
    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    darwin-modules.url = "github:zachcoyle/darwin-modules";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
      };
    };

    sddm-sugar-candy-nix = {
      url = "gitlab:Zhaith-Izaliel/sddm-sugar-candy-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    apple-firmware = {
      url = "github:AdityaGarg8/Apple-Firmware";
      flake = false;
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # flake modules
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };
    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    # overlays
    sg-nvim.url = "github:sourcegraph/sg.nvim";
    telescope-just.url = "github:zachcoyle/telescope-just";
    sword-flake = {
      url = "github:zachcoyle/sword-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
    rustaceanvim.url = "github:mrcjkb/rustaceanvim";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };
    nix-doom-emacs = {
      url = "github:nix-community/nix-doom-emacs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };
    nixpkgs-23-05-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";
    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur.url = "github:nix-community/nur";

    # just for dep management
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    flake-compat.url = "github:edolstra/flake-compat";
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
        "x86_64-linux"
      ];

      flake = {
        nixosConfigurations.nixos = inputs.nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules = [
            ./configuration.nix
            inputs.home-manager.nixosModules.home-manager
            ./common-system.nix
            inputs.sddm-sugar-candy-nix.nixosModules.default
            {
              environment.systemPackages = [inputs.anyrun.packages.x86_64-linux.anyrun];
              nixpkgs.overlays = [
                inputs.sddm-sugar-candy-nix.overlays.default
                inputs.telescope-just.overlays.default
                inputs.sword-flake.overlays.default
                inputs.nixpkgs-firefox-darwin.overlay
                inputs.nix-vscode-extensions.overlays.default
                inputs.nur.overlay
                (_: _: {
                  # Currently broken on unstable
                  rustaceanvim = inputs.rustaceanvim.packages.x86_64-linux.default;
                  sg-nvim = inputs.sg-nvim.legacyPackages.x86_64-linux.sg-nvimsg-nvim;
                  #inherit (inputs.nixpkgs-23-05-nixos.legacyPackages.x86_64-linux) neovide;
                })
              ];
            }
            {
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
      };

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
          name = "system-flake";
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
