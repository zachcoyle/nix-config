{pkgs, ...}: {
  nix = {
    linux-builder = {
      enable = true;
      maxJobs = 4;
      config = _: {
        # insert nixos config here
        # networking = {
        #   hostname = "";
        # };
      };
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  users.users.zcoyle.home = "/Users/zcoyle/";

  services = {
    sketchybar = import ./sketchybar.nix {inherit pkgs;};
    skhd = {
      enable = true;
      skhdConfig = builtins.readFile ./dots/skhdrc;
    };
    yabai = {
      enable = true;
      ##############
      # INFO: SIP must be disabled for enableScriptingAddition to work
      # some yabai features are silently unavailable with it turned off
      # https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
      enableScriptingAddition = true;
      ##############
      config = {
        focus_follows_mouse = "off";
        mouse_follows_focus = "off";
        window_placement = "second_child";
        window_opacity = "on";
        active_window_opacity = 1.0;
        normal_window_opacity = 0.9;
        top_padding = 34;
        bottom_padding = 3;
        left_padding = 3;
        right_padding = 3;
        window_gap = 3;
        layout = "bsp";
      };
      extraConfig = ''
      '';
    };
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
    };
  };
}
