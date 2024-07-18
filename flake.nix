{
  description = "nixos + darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-24.05";

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
        disko.follows = "";
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
      url = "github:hyprwm/hyprpicker/8791f717ef495c8c5a36b21cbccc7cf218fbc380";
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
        fenix.follows = "fenix";
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

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-utils.follows = "flake-utils";
        gitignore.follows = "gitignore";
        # FIXME: see https://github.com/NixOS/nix/issues/5790#issuecomment-996690415
      };
    };

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-btm = {
      url = "github:DieracDelta/nix-btm/0.2.0";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        utils.follows = "flake-utils";
        fenix.follows = "fenix";
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
                inherit (inputs.zls.packages.${prev.system}) zls;
                inherit (inputs.nix-btm.packages.${prev.system}) nix-btm;
              })
            ];
          };

          nixos-overlays = {
            nixpkgs.overlays = [
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

          common-nixos-config =
            { extraModules }:
            (rec {
              system = "x86_64-linux";
              specialArgs = {
                inherit inputs system;
              };
              modules = [
                nixos-overlays
                common-overlays
                ./common-system.nix
                inputs.home-manager.nixosModules.home-manager
                inputs.stylix.nixosModules.stylix
                registryModule
                { nixpkgs.config.rocmSupport = true; }
                (
                  { pkgs, ... }:
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      users.zcoyle = import ./home.nix;
                      extraSpecialArgs = {
                        inherit (inputs) nixvim;
                        pkgsStable = import inputs.nixpkgs-stable { inherit (pkgs) system; };
                      };
                    };
                  }
                )
                {
                  home-manager.users.zcoyle.imports = [
                    inputs.ags.homeManagerModules.default
                    inputs.xremap-flake.homeManagerModules.default
                    ./home-linux.nix
                  ];
                }
              ] ++ extraModules;
            });

          common-darwin-config = {
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

          common-iso-config =
            { extraModules }:
            {
              modules = [
                "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-graphical-calamares-plasma6.nix"
                (
                  { pkgs, lib, ... }:
                  {
                    nixpkgs.hostPlatform = "x86_64-linux";
                    nix = {
                      settings = {
                        experimental-features = "nix-command flakes";
                        auto-optimise-store = true;
                        use-xdg-base-directories = true;
                        substituters = [
                          "https://zachcoyle.cachix.org"
                          "https://nix-community.cachix.org"
                          "https://hyprland.cachix.org"
                          "https://devenv.cachix.org"
                          "https://crane.cachix.org"
                        ];
                        trusted-public-keys = [
                          "zachcoyle.cachix.org-1:Zgr8u70LueWgpbSPM4E8JqxpQcGISxivplq1I9qogGg="
                          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                          "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
                          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
                          "crane.cachix.org-1:8Scfpmn9w+hGdXH/Q9tTLiYAE/2dnJYRJP7kl80GuRk="
                        ];
                      };
                    };
                    boot = {
                      supportedFilesystems = {
                        bcachefs = true;
                        exfat = true;
                        ext4 = true;
                        fat = true;
                        zfs = lib.mkForce false;
                      };
                    };

                    environment.systemPackages = with pkgs; [
                      alacritty
                      git
                      neovim
                    ];
                  }
                )
              ] ++ extraModules;
            };

        in
        {
          darwinConfigurations = {
            mbp13 = inputs.nix-darwin.lib.darwinSystem common-darwin-config;
            mbp15 = inputs.nix-darwin.lib.darwinSystem common-darwin-config;
          };
          nixosConfigurations = {
            nixos-desktop = inputs.nixpkgs.lib.nixosSystem (common-nixos-config {
              extraModules = [
                ./hosts/nixos/nixos-desktop/configuration.nix
                ./hosts/nixos/nixos-desktop/home.nix
                ./modules/gaming.nix
              ];
            });
            nixos-laptop = inputs.nixpkgs.lib.nixosSystem (common-nixos-config {
              extraModules = [
                ./hosts/nixos/nixos-laptop/configuration.nix
                ./hosts/nixos/nixos-laptop/home.nix
                ./modules/gaming.nix
              ];
            });
            iso = inputs.nixpkgs.lib.nixosSystem (common-iso-config {
              extraModules = [
                (
                  { pkgs, ... }:
                  {
                    boot.kernelPackages = pkgs.linuxPackages_latest;
                  }
                )
              ];
            });
            iso-t2 = inputs.nixpkgs.lib.nixosSystem (common-iso-config {
              extraModules = [
                inputs.nixos-hardware.nixosModules.apple-t2
                (
                  { pkgs, ... }:
                  {
                    hardware = {
                      apple-t2.enableAppleSetOsLoader = true;
                      firmware = [
                        (pkgs.stdenvNoCC.mkDerivation {
                          name = "brcm-firmware";
                          buildCommand = ''
                            dir="$out/lib/firmware"
                            mkdir -p "$dir"
                            cp -r ${inputs.apple-firmware}/lib/firmware/* "$dir"
                          '';
                        })
                      ];
                    };
                  }
                )
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
