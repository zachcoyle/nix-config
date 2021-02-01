{ config, lib, pkgs, ... }:
let
  appStoreApps = [
    "1035480615" # Skeebus
    "1037126344" # Apple
    "1039600682" # Hacker
    "1176895641" # Spark
    "1289583905" # Pixelmator
    "1397180934" # Dark
    "1436953057" # Ghostery
    "1480068668" # Messenger
    "408981434" # iMovie
    "409183694" # Keynote
    "409201541" # Pages
    "409203825" # Numbers
    "411643860" # DaisyDisk
    "422501241" # Regex
    "423666302" # Sonance
    "452695239" # QREncoder
    "497799835" # Xcode
    "499233976" # Cathode
    "506189836" # Harvest
    "586001240" # SQLPro
    "587512244" # Kaleidoscope
    "640199958" # Developer
    "682658836" # GarageBand
    "803453959" # Slack
    "924726344" # Deliveries
    "937984704" # Amphetamine
    "957810159" # Raindrop.io
  ];

  vscodeOverrides = {

    vscodeExtensions = with pkgs.vscode-extensions;
      [
        #ms-python.python
        #ms-vsliveshare.vsliveshare
        bbenoist.Nix
        eamodio.gitlens
        esbenp.prettier-vscode
        graphql.vscode-graphql
        jnoortheen.nix-ide
        ms-python.vscode-pylance
      ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
        {
          name = "insert-iso-timestamp";
          publisher = "dpkshrma";
          version = "0.0.1";
          sha256 = "0jhfhybjsl6i3sq1d3q4ryz5lidjk82jzzgq6bbjwjlipj6vdan7";
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
          version = "0.0.78";
          sha256 = "dyXuMITHoLZBOYtLo4Jknf4TkeCysiNGQWkqxMPlfyg=";
        }
        {
          name = "vscode-theme-gruvbox-minor";
          publisher = "adamsome";
          version = "2.2.2";
          sha256 = "gmEzgNWMreMKpbcxpiwt1PCHNuYz2tCvLUB4gMMi7Ws=";
        }
      ];

  };

in
{

  nixpkgs.overlays = [ (import ./overlays/customPackages.nix) ];

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
        mineffect = "suck";
        mouse-over-hilite-stack = true;
        mru-spaces = false;
        orientation = "left";
        show-process-indicators = true;
        show-recents = true;
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
    fonts = with pkgs; [ nerdfonts ];
  };


  environment.systemPackages = with pkgs; [
    fstl
    synergy
    terminal-notifier
    emacs
    wireshark
    alacritty
    iterm2
    nur.repos.zachcoyle.xcodeproj
    # need to fix to make it show up in ~/Applications/Nix/
    (vscode-with-extensions.override (vscodeOverrides // { vscode = pkgs.vscode; }))
    (vscode-with-extensions.override (vscodeOverrides // { vscode = pkgs.vscodium; }))
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
      mouse_follows_focus = "off";
      window_placement = "second_child";
      window_opacity = "on";
      active_window_opacity = 1.0;
      normal_window_opacity = 0.9;
      top_padding = 3;
      bottom_padding = 3;
      left_padding = 3;
      right_padding = 3;
      window_gap = 3;
      layout = "bsp";
    };
  };

  services.skhd = {
    enable = true;
    skhdConfig = builtins.readFile ./modules/dotfiles/dotfiles/skhdrc;
  };

  programs.bash.enable = true;
  programs.zsh.enable = true;

  launchd = { };

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
    ${pkgs.nur.repos.zachcoyle.mas}/bin/mas install ${lib.concatStringsSep " " appStoreApps}
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
