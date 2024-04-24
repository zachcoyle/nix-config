{
  description = "nixos + darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-modules.url = "github:zachcoyle/darwin-modules";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        pre-commit-hooks.follows = "pre-commit-hooks";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "nix-darwin";
        flake-compat.follows = "flake-compat";
      };
    };

    nixneovimplugins = {
      url = "github:NixNeovim/NixNeovimPlugins";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        poetry2nix.follows = "poetry2nix";
      };
    };

    systems-linux.url = "github:nix-systems/default-linux";
    systems-darwin.url = "github:nix-systems/default-darwin";
    systems-default.url = "github:nix-systems/default";

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
      };
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        poetry2nix.follows = "poetry2nix";
      };
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        flake-compat.follows = "flake-compat";
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

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
      };
    };

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        flake-compat.follows = "flake-compat";
        gitignore.follows = "gitignore";
      };
    };

    sg-nvim = {
      url = "github:sourcegraph/sg.nvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        pre-commit-nix.follows = "pre-commit-hooks";
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

    rippkgs = {
      url = "github:replit/rippkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        flake-parts.follows = "flake-parts";
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

    # FIXME: https://github.com/NixOS/nixpkgs/issues/290611
    nixpkgs-23-05-darwin.url = "github:NixOS/nixpkgs/nixpkgs-23.05-darwin";

    nixpkgs-firefox-darwin = {
      url = "github:bandithedoge/nixpkgs-firefox-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur.url = "github:nix-community/nur";

    flake-utils.url = "github:numtide/flake-utils";
    flake-compat.url = "github:edolstra/flake-compat";
    poetry2nix = {
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        systems.follows = "systems-default";
      };
    };

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        gitignore.follows = "gitignore";
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
        registryModule.nix.registry.nixpkgs.flake = inputs.nixpkgs;

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
                    inherit (inputs) nixvim hyprlock hypridle hyprland-plugins;
                  };
                };
              }
              {
                home-manager.users.zcoyle.imports = [
                  inputs.hyprlock.homeManagerModules.default
                  inputs.hypridle.homeManagerModules.default
                  inputs.ags.homeManagerModules.default
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
            ./modules/darwin/dock.nix
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
        wallpaperDir = ./theme/wallpapers;
      in {
        darwinConfigurations = {
          mbp13 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
          mbp15 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
        };
        nixosConfigurations = {
          nixos-desktop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              ./hosts/nixos/nixos-desktop/configuration.nix
              {
                # TODO: host-specific home file
                home-manager.users.zcoyle.wayland.windowManager.hyprland.settings = {
                  exec-once = [
                    "swww img ${wallpaperDir}/platform.jpg --transition-fps 60 --transition-type grow --transition-pos 1695,855"
                  ];
                  bind = [
                    "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 1695,855"
                  ];
                  monitor = [
                    "HDMI-A-1, 1920x1080@60, 0x0, 1"
                  ];
                };
              }
            ];
          });
          nixos-laptop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
            extraModules = [
              ./hosts/nixos/nixos-laptop/configuration.nix
              {
                # TODO: host-specific home file
                home-manager.users.zcoyle.wayland.windowManager.hyprland.settings = {
                  exec-once = [
                    "swww img ${wallpaperDir}/platform.jpg --transition-fps 60 --transition-type grow --transition-pos 2622,1470"
                  ];
                  bind = [
                    "SUPER, P, exec, swww img ${wallpaperDir}/`ls ${wallpaperDir} | shuf -n 1` --transition-fps 60 --transition-type grow --transition-pos 2622,1470"
                  ];
                  monitor = [
                    "DP-1, 3072x1920@60, 1920x540, 1"
                    "DP-6, 1920x1080@60, 0x0, 1"
                  ];
                };
              }
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
            dart-sass
            just
            deadnix
            alejandra
            statix
          ];
        };
      };
    };
}
