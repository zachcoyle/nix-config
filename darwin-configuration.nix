{ config, lib, pkgs, ... }:
let
  appStoreApps = [
    "499233976" #  Cathode        
    "1480068668" #   Messenger      
    "1289583905" #   Pixelmator     
    "587512244" #  Kaleidoscope   
    "640199958" #  Developer      
    "409183694" #  Keynote        
    "586001240" #  SQLPro         
    "1436953057" #   Ghostery       
    "1039600682" #   Hacker         
    "937984704" #  Amphetamine    
    "682658836" #  GarageBand     
    "411643860" #  DaisyDisk      
    "409203825" #  Numbers        
    "497799835" #  Xcode          
    "423666302" #  Sonance        
    "409201541" #  Pages          
    "422501241" #  Regex          
    "506189836" #  Harvest        
    "408981434" #  iMovie         
    "1037126344" #   Apple          
    "1035480615" #   Skeebus        
    "803453959" #  Slack          
    "1176895641" #   Spark          
    "1397180934" #   Dark           
    "452695239" #  QREncoder      
    "924726344" #  Deliveries     
    "957810159" #  Raindrop.io    
  ];

  vscodeOverrides = {

    vscodeExtensions = with pkgs.vscode-extensions;
      [ bbenoist.Nix ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
          version = "2020.10.332292344";
          sha256 = "qgr/WT9euPMQot+dzGZqm+5z8KYx3svOftC8tb60gzA=";
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
        #{
        #  name = "vsliveshare";
        #  publisher = "ms-vsliveshare";
        #  version = "1.0.3071";
        #  sha256 = "8jhH2U/nwp2XqS55tVTAgnV+F+T+qcyvlxe1BtQPlf0=";
        #}
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
    xcodeproj
    # need to fix to make it show up in ~/Applications/Nix/
    #(vscode-with-extensions.override (vscodeOverrides // { vscode = pkgs.vscode; }))
    #(vscode-with-extensions.override (vscodeOverrides // { vscode = pkgs.vscodium; }))
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
      top_padding = 35;
      bottom_padding = 5;
      left_padding = 8;
      right_padding = 5;
      window_gap = 5;
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
