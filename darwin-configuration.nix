{ config, lib, pkgs, ... }:
let
  homebridgePkgs = pkgs.yarn2nix-moretea.mkYarnPackage {
    name = "homebridgePkgs";
    src = ./pkgs/node_packages/homebridgePkgs;
    packageJSON = ./pkgs/node_packages/homebridgePkgs/package.json;
    yarnLock = ./pkgs/node_packages/homebridgePkgs/yarn.lock;
    publishBinsFor = [ "homebridge" ];
  };

  appStoreApps = [
    "937984704" #   Amphetamine
    "1037126344" #   Apple
    "499233976" #   Cathode
    "924726344" #   Deliveries
    "640199958" #   Developer
    "1377718068" #   Game
    "682658836" #   GarageBand
    "1436953057" #   Ghostery
    "506189836" #   Harvest
    "408981434" #   iMovie
    "587512244" #   Kaleidoscope
    "409183694" #   Keynote
    "1480068668" #   Messenger
    "409203825" #   Numbers
    "409201541" #   Pages
    "1289583905" #   Pixelmator
    "422501241" #   Regex
    "1035480615" #   Skeebus
    "803453959" #   Slack
    "423666302" #   Sonance
    "1176895641" #   Spark
    "586001240" #   SQLPro
    "497799835" #   Xcode
  ];

in
{

  nixpkgs.overlays = [
    (import ./overlays/customPackages.nix)
    (import ./overlays/darwin-enable.nix)
  ];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin-configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin-configuration.nix";

  environment.variables.MACOSX_DEPLOYMENT_TARGET = "10.15";

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      dock = {
        autohide = false;
        dashboard-in-overlay = false;
        mineffect = null; #"suck";
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        orientation = "left";
        show-process-indicators = true;
        show-recents = false;
        showhidden = true;
        tilesize = 12;
      };

      finder = {
        _FXShowPosixPathInTitle = true;
        AppleShowAllExtensions = true;
        FXEnableExtensionChangeWarning = false;
        QuitMenuItem = true;
      };

      trackpad = {
        Clicking = true;
        Dragging = true;
        TrackpadRightClick = false;
        TrackpadThreeFingerDrag = false;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        #AppleAccentColor = "Green";
        AppleInterfaceStyle = "Dark";
        AppleKeyboardUIMode = 3;
        ApplePressAndHoldEnabled = true;
        InitialKeyRepeat = 20;
        KeyRepeat = 10;
        NSAutomaticCapitalizationEnabled = false;
        NSAutomaticDashSubstitutionEnabled = false;
        NSAutomaticPeriodSubstitutionEnabled = false;
        NSAutomaticQuoteSubstitutionEnabled = false;
        NSAutomaticSpellingCorrectionEnabled = false;
        NSNavPanelExpandedStateForSaveMode = true;
        NSNavPanelExpandedStateForSaveMode2 = true;
        PMPrintingExpandedStateForPrint = true;
        PMPrintingExpandedStateForPrint2 = true;
      };
    };
  };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      fantasque-sans-mono
      fira-code
      iosevka
      nerdfonts
      open-dyslexic
      open-sans
      powerline-fonts
      roboto-mono
      source-code-pro
    ];
  };


  environment.systemPackages = with pkgs; [
    airdrop-cli
    fstl
    synergy
    terminal-notifier
    emacs
    wireshark
    alacritty
    iterm2
    mas
    segno
    xcodeproj
    # need to fix to make it show up in ~/Applications/Nix/
    (vscode-with-extensions.override {
      vscode = vscodium;
      vscodeExtensions = with vscode-extensions;
        [
          vscode-extensions.bbenoist.Nix
        ] ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "gitlens";
            publisher = "eamodio";
            version = "10.2.1";
            sha256 = "1bh6ws20yi757b4im5aa6zcjmsgdqxvr1rg86kfa638cd5ad1f97";
          }
          {
            name = "insert-iso-timestamp";
            publisher = "dpkshrma";
            version = "0.0.1";
            sha256 = "0jhfhybjsl6i3sq1d3q4ryz5lidjk82jzzgq6bbjwjlipj6vdan7";
          }
          {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "5.0.0";
            sha256 = "018n0632gp65b3qwww8ijyb149v8dvbhlys548wvjfax8926jm5j";
          }
          {
            name = "pyright";
            publisher = "ms-pyright";
            version = "1.1.40";
            sha256 = "1qgmi0pzimglvpky8bvskcxdgbgha2l9srilzsaqj0dlvavp0969";
          }
          {
            name = "python";
            publisher = "ms-python";
            version = "2020.8.101144";
            sha256 = "1ppsqs4lyxighqqia9195k2sgcv7455kzms49pmc4i3p9s3gcmny";
          }
          {
            name = "uuid-generator";
            publisher = "netcorext";
            version = "0.0.4";
            sha256 = "00r7jxl6b1gfxm78payi9mr49bcnkrzzc5wyvk5j1jarg2sqzbfh";
          }
          {
            name = "vscode-neovim";
            publisher = "asvetliakov";
            version = "0.0.50";
            sha256 = "1dhqqam6dqig7rp0ii6z4h97a154133mq3dmq1p1g5i4v4qykrl5";
          }
        ];
    })
  ];

  programs.man.enable = true;

  services.nix-daemon.enable = true;
  nix.package = pkgs.nixUnstable;
  nixpkgs.config.allowUnfree = true;
  programs.nix-index.enable = false;

  services.lorri = {
    logFile = "/var/tmp/lorri.log";
    enable = true;
  };

  services.redis.enable = true;


  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    config = {
      focus_follows_mouse = "off";
      mouse_follows_focus = "on";
      window_placement = "second_child";
      window_opacity = "on";
      active_window_opacity = 1.0;
      normal_window_opacity = 0.9;
      top_padding = 5;
      bottom_padding = 5;
      left_padding = 8;
      right_padding = 5;
      window_gap = 5;
      layout = "bsp";
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./dotfiles/skhdrc;
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  launchd =
    {
      agents = {
        homebridge = {
          command = "${homebridgePkgs}/bin/homebridge --user-storage-path /Users/zcoyle/.homebridge";
          serviceConfig = {
            Label = "homebridge";
            UserName = "zcoyle";
            KeepAlive = true;
            StandardOutPath = "/var/tmp/homebridge.log";
            StandardErrorPath = "/var/tmp/homebridge_error.log";
          };
        };
      };
    };


  #TEMP WORKAROUND. See https://github.com/LnL7/nix-darwin/issues/139#issuecomment-666771621
  #system.activationScripts.applications.text = pkgs.lib.mkForce (
  #  ''
  #    echo "setting up $HOME/Applications/Nix..."
  #    rm "$HOME/Applications/Nix"
  #    ln -s "${config.system.build.applications}/Applications" "$HOME/Applications/Nix"
  #  ''
  #);

  networking = {
    knownNetworkServices = [
      "Wi-Fi"
      "Bluetooth PAN"
      "Thunderbolt Bridge"
    ];
    dns = [
      "1.1.1.1"
      "1.0.0.1"
      "2606:4700:4700::1111"
      "2606:4700:4700::1001"
    ];
  };

  system.activationScripts.extraUserActivation.text = ''
    echo "setting up App Store applications..."
    ${pkgs.mas}/bin/mas upgrade
    ${pkgs.mas}/bin/mas install ${lib.concatStringsSep " " appStoreApps}
  '';

  #users.users.zcoyle.shell = pkgs.zsh;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 3;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 8;
  nix.buildCores = 8;

}
