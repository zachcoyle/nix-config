{
  description = "Darwin system flake";

  inputs = {
    # system
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

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
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "nix-darwin";
      };
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    systems-linux.url = "github:nix-systems/default-linux";
    systems-darwin.url = "github:nix-systems/default-darwin";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
      };
    };

    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };

    base16.url = "github:SenchoPens/base16.nix";

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        base16.follows = "base16";
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

    # flake modules
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
      };
    };

    # overlays
    sg-nvim = {
      url = "github:sourcegraph/sg.nvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
      };
    };

    telescope-just = {
      url = "github:zachcoyle/telescope-just";
      inputs = {
        devshell.follows = "devshell";
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };

    sword-flake = {
      url = "github:zachcoyle/sword-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    #neorocks = {
    #  url = "github:nvim-neorocks/neorocks";
    #  inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #    flake-compat.follows = "flake-compat";
    #    flake-utils.follows = "flake-utils";
    #    pre-commit-hooks.follows = "pre-commit-hooks";
    #  };
    #};

    rustaceanvim = {
      url = "github:mrcjkb/rustaceanvim";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        pre-commit-hooks.follows = "pre-commit-hooks";
        #neorocks.follows = "neorocks";
      };
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        flake-parts.follows = "flake-parts";
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
      };
    };

    yofi = {
      url = "github:l4l/yofi";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
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

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      systems = (import inputs.systems-darwin) ++ (import inputs.systems-linux);

      flake = let
        common_nixos_config = {extraModules}: {
          system = "x86_64-linux";
          specialArgs = {inherit inputs;};
          modules =
            [
              ./hosts/nixos/overlays.nix
              ./hosts/common-overlays.nix
              ./common-system.nix
              inputs.home-manager.nixosModules.home-manager
              inputs.sddm-sugar-candy-nix.nixosModules.default
              inputs.stylix.nixosModules.stylix
              (
                {lib, ...}: {
                  nixpkgs = {
                    config = {
                      # enable when ollama updates
                      rocmSupport = false;
                      allowUnfreePredicate = pkg:
                        builtins.elem (lib.getName pkg) [
                          "dwarf-fortress" # proprietary
                          "steam" # proprietary
                          "steam-original" # proprietary
                          "steam-run" # proprietary
                          "hayabusa" # CCA NC ND 4.0
                        ];
                    };
                  };
                }
              )
              {
                home-manager = {
                  useGlobalPkgs = true;
                  useUserPackages = true;
                  users.zcoyle = import ./home.nix;
                  extraSpecialArgs = {
                    inherit (inputs) nixvim hycov hyprland-plugins;
                  };
                };
              }
            ]
            ++ extraModules;
        };
        common_darwin_config = {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/darwin/overlays.nix
            ./hosts/common-overlays.nix
            ./common-system.nix
            ./darwin.nix
            inputs.darwin-modules.darwinModule
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            {
              system.configurationRevision = self.rev or self.dirtyRef or null;
              nixpkgs = {
                config = {
                  allowUnfree = true;
                };
              };
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users.zcoyle = import ./home.nix;
                extraSpecialArgs = {
                  inherit (inputs) nixvim;
                };
              };
            }
          ];
        };
      in {
        darwinConfigurations = {
          mbp13 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
          mbp15 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
        };
        nixosConfigurations = {
          nixos-desktop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              ./hosts/nixos/nixos-desktop/configuration.nix
            ];
          });
          nixos-laptop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              ./hosts/nixos/nixos-laptop/configuration.nix
            ];
          });
          live = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./hosts/nixos/nixos-laptop/configuration.nix
              (
                {lib, ...}: {
                  networking.wireless.enable = lib.mkForce false;
                }
              )
            ];
          });
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
