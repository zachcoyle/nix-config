{
  description = "nixos + darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin-modules.url = "github:zachcoyle/darwin-modules";

    dustinlyons-modules = {
      url = "github:dustinlyons/nixos-config";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        darwin.follows = "nix-darwin";
        disko.follows = "disko";
        agenix.follows = "";
        secrets.follows = "";
        homebrew-bundle.follows = "";
        homebrew-cask.follows = "";
        homebrew-core.follows = "";
        nix-homebrew.follows = "";
      };
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        git-hooks.follows = "pre-commit-hooks";
        flake-compat.follows = "flake-compat";
        flake-parts.follows = "flake-parts";
        hercules-ci-effects.follows = "hercules-ci-effects";
      };
    };

    neovim-plugins-nightly-overlay = {
      url = "github:zachcoyle/neovim-plugins-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        flake-parts.follows = "flake-parts";
        hercules-ci-effects.follows = "hercules-ci-effects";
      };
    };

    icon-themes-nightly-overlay = {
      url = "github:zachcoyle/icon-themes-nightly-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        devshell.follows = "devshell";
        systems.follows = "systems-linux";
      };
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        git-hooks.follows = "pre-commit-hooks";
        flake-parts.follows = "flake-parts";
        home-manager.follows = "home-manager";
        nix-darwin.follows = "nix-darwin";
        flake-compat.follows = "flake-compat";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    systems-linux.url = "github:nix-systems/default-linux";
    systems-darwin.url = "github:nix-systems/default-darwin";
    systems-default.url = "github:nix-systems/default";

    hyprlang = {
      url = "github:hyprwm/hyprlang";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
      };
    };

    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        hyprlang.follows = "hyprlang";
      };
    };

    hypridle = {
      url = "github:hyprwm/hypridle";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprlock = {
      url = "github:hyprwm/hyprlock";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        hyprlang.follows = "hyprlang";
      };
    };

    hyprpicker = {
      url = "github:hyprwm/hyprpicker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        hyprlang.follows = "hyprlang";
      };
    };

    pyprland = {
      url = "github:hyprland-community/pyprland";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems-linux";
        poetry2nix.follows = "poetry2nix";
        flake-compat.follows = "flake-compat";
      };
    };

    ags = {
      url = "github:Aylur/ags";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    libastal = {
      url = "github:astal-sh/libastal";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    xremap-flake = {
      url = "github:xremap/nix-flake";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
        devshell.follows = "devshell";
        hyprland.follows = "hyprland";
        home-manager.follows = "home-manager";
        treefmt-nix.follows = "treefmt-nix";
        crane.follows = "crane";
      };
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
      url = "github:Zhaith-Izaliel/sddm-sugar-candy-nix";
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
      url = "github:cachix/git-hooks.nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
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
        # FIXME: see https://github.com/NixOS/nix/issues/5790#issuecomment-996690415
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

    rippkgs = {
      url = "github:replit/rippkgs";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        devshell.follows = "devshell";
        flake-parts.follows = "flake-parts";
        crane.follows = "crane";
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

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    crane = {
      url = "github:ipetkov/crane";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hercules-ci-effects = {
      url = "github:hercules-ci/hercules-ci-effects";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-parts.follows = "flake-parts";
      };
    };

    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        systems.follows = "systems-default";
        treefmt-nix.follows = "treefmt-nix";
      };
    };

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        gitignore.follows = "gitignore";
        # FIXME: see https://github.com/NixOS/nix/issues/5790#issuecomment-996690415
      };
    };

    nix-btm = {
      url = "github:DieracDelta/nix-btm";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
        # fenix.follows = "fenix";
      };
    };

    logos.url = "github:zachcoyle/logos.nix";
  };

  outputs =
    inputs@{ self, ... }:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      systems = (import inputs.systems-darwin) ++ (import inputs.systems-linux);

      flake =
        let
          registryModule.nix.registry.nixpkgs.flake = inputs.nixpkgs;

          common-overlays = {
            nixpkgs.overlays = [
              inputs.telescope-just.overlays.default
              inputs.nix-vscode-extensions.overlays.default
              inputs.nur.overlay
              inputs.rippkgs.overlays.default
              inputs.neovim-nightly-overlay.overlays.default
              inputs.neovim-plugins-nightly-overlay.overlays.default

              (_: prev: {
                inherit (inputs.sg-nvim.legacyPackages.${prev.system}) sg-nvim;
                inherit (inputs.zls.packages.${prev.system}) zls;
                inherit (inputs.nix-btm.packages.${prev.system}) nix-btm;
              })
            ];
          };

          nixos-overlays = {
            nixpkgs.overlays = [
              inputs.sddm-sugar-candy-nix.overlays.default
              inputs.hyprland.overlays.default
              inputs.icon-themes-nightly-overlay.overlays.default
              inputs.xremap-flake.overlays.default
              (_: prev: {
                inherit (inputs.ags.packages.${prev.system}) ags;
                inherit (inputs.hypridle.packages.${prev.system}) hypridle;
                inherit (inputs.hyprlock.packages.${prev.system}) hyprlock;
                inherit (inputs.hyprpicker.packages.${prev.system}) hyprpicker;
                inherit (inputs.hyprpaper.packages.${prev.system}) hyprpaper;
                inherit (inputs.libastal.packages.${prev.system}) astal;
                inherit (inputs.pyprland.packages.${prev.system}) pyprland;
                inherit (inputs.quickshell.packages.${prev.system}) quickshell;

                logos = inputs.logos.packages.${prev.system}.default;

                # FIXME: https://github.com/NixOS/nixpkgs/issues/298539
                rofi-calc = prev.rofi-calc.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
                rofi-emoji = prev.rofi-emoji.override { rofi-unwrapped = prev.rofi-wayland-unwrapped; };
              })
            ];
          };

          darwin-overlays = {
            nixpkgs.overlays = [
              inputs.nixpkgs-firefox-darwin.overlay
              (_: prev: { inherit (inputs.nixpkgs-23-05-darwin.legacyPackages.${prev.system}) neovide; })
            ];
          };

          common_nixos_config =
            { extraModules }:
            {
              system = "x86_64-linux";
              specialArgs = {
                inherit inputs;
              };
              modules = [
                nixos-overlays
                common-overlays
                ./common-system.nix
                inputs.home-manager.nixosModules.home-manager
                inputs.sddm-sugar-candy-nix.nixosModules.default
                inputs.stylix.nixosModules.stylix
                registryModule
                (
                  { lib, ... }:
                  {
                    nixpkgs = {
                      config = {
                        rocmSupport = true;
                        allowUnfreePredicate =
                          pkg:
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
                      inherit (inputs) nixvim;
                    };
                  };
                }
                {
                  home-manager.users.zcoyle.imports = [
                    inputs.ags.homeManagerModules.default
                    inputs.xremap-flake.homeManagerModules.default
                    ./home-linux.nix
                  ];
                }
              ] ++ extraModules;
            };

          common_darwin_config = {
            specialArgs = {
              inherit inputs;
            };
            modules = [
              darwin-overlays
              common-overlays
              ./common-system.nix
              ./hosts/darwin/common-configuration.nix
              inputs.darwin-modules.darwinModule
              inputs.home-manager.darwinModules.home-manager
              inputs.stylix.darwinModules.stylix
              "${inputs.dustinlyons-modules}/modules/darwin/dock"
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
              { home-manager.users.zcoyle.imports = [ ./home-darwin.nix ]; }
            ];
          };
        in
        {
          darwinConfigurations = {
            mbp13 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
            mbp15 = inputs.nix-darwin.lib.darwinSystem common_darwin_config;
          };
          nixosConfigurations = {
            nixos-desktop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
              extraModules = [
                ./hosts/nixos/nixos-desktop/configuration.nix
                ./hosts/nixos/nixos-desktop/home.nix
              ];
            });
            nixos-laptop = inputs.nixpkgs.lib.nixosSystem (common_nixos_config {
              extraModules = [
                ./hosts/nixos/nixos-laptop/configuration.nix
                ./hosts/nixos/nixos-laptop/home.nix
              ];
            });
          };
        };

      perSystem =
        { config, pkgs, ... }:
        {
          formatter = pkgs.nixfmt-rfc-style;

          pre-commit = {
            settings = {
              hooks = {
                nixfmt = {
                  enable = true;
                  package = pkgs.nixfmt-rfc-style;
                };
                deadnix.enable = true;
                nil.enable = true;
                statix.enable = true;
              };
            };
          };

          devshells.default = {
            name = "system-flake";
            env = [ ];
            devshell.startup.pre-commit-hooks.text = ''
              ${config.pre-commit.installationScript}
            '';
            packages = with pkgs; [
              dart-sass
              just
              deadnix
              nixfmt-rfc-style
              statix
            ];
          };
        };
    };
}
