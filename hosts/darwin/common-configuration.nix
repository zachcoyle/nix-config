{ pkgs, ... }:
{

  imports = [ ../../theme/stylix.nix ];

  nix = {
    linux-builder = {
      enable = true;
      maxJobs = 4;
      config = _: {
        # insert nixos config here
      };
    };
  };

  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  users.users.zcoyle.home = "/Users/zcoyle/";

  environment.systemPackages = with pkgs; [
    dockutil
    jankyborders
  ];

  services = {
    karabiner-elements.enable = false;
    nix-daemon.enable = true;
    # tailscale.enable = true;
  };

  programs.zsh.enable = true;

  security = {
    pam.enableSudoTouchIdAuth = true;
  };

  system = {
    keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
    };

    defaults = {
      ActivityMonitor = {
        ShowCategory = 100;
        IconType = 6;
      };

      CustomUserPreferences = { };

      dock = {
        autohide = false;
        dashboard-in-overlay = false;
        mineffect = "suck";
        mouse-over-hilite-stack = true;
        magnification = true;
        largesize = 128;
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
        FXPreferredViewStyle = "clmv";
        ShowPathbar = true;
        ShowStatusBar = true;
        QuitMenuItem = true;
      };

      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true;
        AppleAccentColor = "Green";
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

      screencapture.location = "/Users/zcoyle/Pictures/Screenshots/";

      trackpad = {
        Clicking = true;
        Dragging = true;
        TrackpadRightClick = false;
        TrackpadThreeFingerDrag = false;
      };

      universalaccess = {
        closeViewScrollWheelToggle = true;
        closeViewZoomFollowsFocus = true;
      };
    };
  };

  # INFO: This mitigates firefox balking about read-only ini
  # https://github.com/nix-community/home-manager/issues/3323#issuecomment-1280055087
  launchd.agents.FirefoxEnv = {
    serviceConfig.ProgramArguments = [
      "/bin/sh"
      "-c"
      "launchctl setenv MOZ_LEGACY_PROFILES 1; launchctl setenv MOZ_ALLOW_DOWNGRADE 1"
    ];
    serviceConfig.RunAtLoad = true;
  };

  local.dock = {
    enable = true;
    entries = [
      { path = "/System/Applications/Utilities/Activity\ Monitor.app"; }
      { path = "/Applications/Safari.app"; }
      { path = "${pkgs.firefox-bin}/Applications/Firefox.app"; }
      { path = "/System/Applications/Messages.app"; }
      { path = "/System/Applications/Mail.app"; }
      { path = "/System/Applications/Freeform.app"; }
      { path = "/System/Applications/Notes.app"; }
      { path = "/Applications/Xcode-beta.app"; }
      # { path = "${pkgs.alacritty}/Applications/Alacritty.app"; }
      { path = "/Applications/Ghostty.app"; }
      { path = "/Applications/Fork.app"; }
      { path = "/Applications/Neovide.app"; }
      { path = "/Applications/Logos.app"; }
      { path = "/System/Applications/System\ Settings.app"; }
      {
        path = "/Applications";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
      {
        path = "~/Downloads";
        section = "others";
        options = "--sort name --view grid --display folder";
      }
    ];
  };
}
