{
  description = "nixos + darwin system flake";

  inputs = {
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
        flake-compat.follows = "flake-compat";
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

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        # hyprlang.follows = "hyprlang";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        # hyprlang.follows = "hyprlang";
      };
    };

    hycov = {
      url = "github:DreamMaoMao/hycov";
      inputs.hyprland.follows = "hyprland";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
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

    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
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

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };
  };

  outputs = inputs @ {self, ...}:
    inputs.flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      systems = (import inputs.systems-darwin) ++ (import inputs.systems-linux);

      flake = let
        registryModule = {
          nix.registry = {
            nixpkgs.flake = inputs.nixpkgs;
            nur.flake = inputs.nur;
          };
        };
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
              registryModule
              (
                {lib, ...}: {
                  nixpkgs = {
                    config = {
                      rocmSupport = true;
                      allowUnfreePredicate = pkg:
                        builtins.elem (lib.getName pkg) [
                          "dwarf-fortress"
                          "steam"
                          "steam-original"
                          "steam-run"
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
                    inherit (inputs) nixvim hycov hyprlock hypridle;
                  };
                };
              }
              {
                home-manager.users.zcoyle.imports = [
                  inputs.hyprlock.homeManagerModules.default
                  inputs.hypridle.homeManagerModules.default
                  ./home-linux.nix
                ];
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
            ./hosts/darwin/common-configuration.nix
            inputs.darwin-modules.darwinModule
            inputs.home-manager.darwinModules.home-manager
            inputs.stylix.darwinModules.stylix
            registryModule
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
          live-non-t2 = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
              ./hosts/nixos/nixos-desktop/configuration.nix
              (
                {lib, ...}: {
                  networking.wireless.enable = lib.mkForce false;
                }
              )
            ];
          });
          live-t2 = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-gnome.nix"
              ./hosts/nixos/nixos-laptop/configuration.nix
              (
                {lib, ...}: {
                  networking.wireless.enable = lib.mkOverride 0 false;
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
