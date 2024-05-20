{
  pkgs,
  lib,
  ...
}: let
  buildSkhdBinding = {
    mods,
    key,
    command,
    ...
  }: ''
    ${lib.concatStringsSep " + " mods} - ${key} : ${command}
  '';
in {
  nix = {
    linux-builder = {
      enable = true;
      maxJobs = 4;
      config = _: {
        # insert nixos config here
      };
    };
  };

  stylix = import ../../theme/stylix.nix {inherit pkgs;};

  # INFO: Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "x86_64-darwin";

  users.users.zcoyle.home = "/Users/zcoyle/";

  environment.systemPackages = with pkgs; [
    dockutil
    jankyborders
  ];

  services = {
    nix-daemon.enable = true;

    skhd = {
      enable = true;
      # TODO: make these more ergonomic
      skhdConfig = lib.concatStrings (builtins.map buildSkhdBinding [
        {
          mods = ["fn" "shift"];
          key = "q";
          command = ''launchctl kickstart -k "gui/''${UID}/homebrew.mxcl.yabai"; skhd --reload'';
        }
        # Move focus
        {
          mods = ["fn"];
          key = "h";
          command = "yabai -m window --focus west";
        }
        {
          mods = ["fn"];
          key = "j";
          command = "yabai -m window --focus south";
        }
        {
          mods = ["fn"];
          key = "k";
          command = "yabai -m window --focus north";
        }
        {
          mods = ["fn"];
          key = "l";
          command = "yabai -m window --focus east";
        }
        # Swap
        {
          mods = ["fn" "shift"];
          key = "h";
          command = "yabai -m window --swap west";
        }
        {
          mods = ["fn" "shift"];
          key = "j";
          command = "yabai -m window --swap south";
        }
        {
          mods = ["fn" "shift"];
          key = "k";
          command = "yabai -m window --swap north";
        }
        {
          mods = ["fn" "shift"];
          key = "l";
          command = "yabai -m window --swap east";
        }
        # Move
        {
          mods = ["shift" "cmd"];
          key = "h";
          command = "yabai -m window --warp west";
        }
        {
          mods = ["shift" "cmd"];
          key = "j";
          command = "yabai -m window --warp south";
        }
        {
          mods = ["shift" "cmd"];
          key = "k";
          command = "yabai -m window --warp north";
        }
        {
          mods = ["shift" "cmd"];
          key = "l";
          command = "yabai -m window --warp east";
        }
        # Balance
        {
          mods = ["shift" "alt"];
          key = "0";
          command = "yabai -m space --balance";
        }
        # Fill
        {
          mods = ["shift" "alt"];
          key = "up";
          command = "yabai -m window --grid 1:1:0:0:1:1";
        }
        # create desktop, move window and follow focus
        {
          mods = ["shift" "cmd"];
          key = "n";
          # FIXME:
          command = lib.concatStringsSep "\n" [
            ''yabai -m space --create && \''
            ''index="''$(yabai -m query --spaces --display | jq 'map(select(."is-native-fullscreen" == false))[-1].index')" && \''
            ''yabai -m window --space "''${index}" && \''
            ''yabai -m space --focus "''${index}''
          ];
        }
        # Focus
        {
          mods = ["cmd" "alt"];
          key = "x";
          command = "yabai -m space --focus recent";
        }
        {
          mods = ["cmd" "alt"];
          key = "1";
          command = "yabai -m space --focus 1";
        }
        # Move to space and follow focus
        {
          mods = ["shift" "cmd"];
          key = "2";
          command = "yabai -m window --space 2; yabai -m space --focus 2";
        }
        # Focus monitor
        {
          mods = ["ctrl" "alt"];
          key = "z";
          command = "yabai -m display --focus prev";
        }
        {
          mods = ["ctrl" "alt"];
          key = "3";
          command = "yabai -m display --focus 3";
        }
        {
          mods = ["ctrl" "cmd"];
          key = "c";
          command = "yabai -m window --display next; yabai -m display --focus next";
        }
        {
          mods = ["shift" "ctrl"];
          key = "a";
          command = "yabai -m window --move rel:-20:0";
        }
        {
          mods = ["shift" "ctrl"];
          key = "s";
          command = "yabai -m window --move rel:0:20";
        }
        {
          mods = ["shift" "alt"];
          key = "a";
          command = "yabai -m window --resize left:-20:0";
        }
        {
          mods = ["shift" "alt"];
          key = "w";
          command = "yabai -m window --resize top:0:-20";
        }
        {
          mods = ["alt"];
          key = "d";
          command = "yabai -m window --toggle zoom-parent";
        }
        {
          mods = ["alt"];
          key = "f";
          command = "yabai -m window --toggle zoom-fullscreen";
        }
        {
          mods = ["alt"];
          key = "e";
          command = "yabai -m window --toggle split";
        }
        {
          mods = ["alt"];
          key = "t";
          command = "yabai -m window --toggle float --grid 4:4:1:1:2:2";
        }
        {
          mods = ["alt"];
          key = "p";
          command = "yabai -m window --toggle sticky --toggle pip";
        }
        {
          mods = ["cmd"];
          key = "return";
          command = "alacritty";
        }
      ]);
    };

    # tailscale.enable = true;

    yabai = {
      enable = true;
      ##############
      # NOTE: SIP must be disabled for enableScriptingAddition to work
      # some yabai features are silently unavailable with it turned off
      # https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection
      enableScriptingAddition = true;
      ##############
      config = {
        active_window_opacity = 1.0;
        bottom_padding = 10;
        focus_follows_mouse = "autoraise";
        layout = "bsp";
        left_padding = 10;
        mouse_follows_focus = "on";
        normal_window_opacity = 0.8;
        right_padding = 10;
        top_padding = 10;
        window_animation_duration = 0.1;
        window_animation_easing = "ease_out_circ";
        window_gap = 10;
        window_opacity = "on";
        window_placement = "second_child";
      };
      extraConfig = ''
        borders&
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
      ActivityMonitor = {
        ShowCategory = 100;
        IconType = 6;
      };

      CustomUserPreferences = {};

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
      {path = "/System/Applications/Utilities/Activity\ Monitor.app";}
      {path = "/Applications/Safari.app";}
      {path = "${pkgs.firefox-bin}/Applications/Firefox.app";}
      {path = "/System/Applications/Messages.app";}
      {path = "/System/Applications/Mail.app";}
      {path = "/System/Applications/Freeform.app";}
      {path = "/System/Applications/Notes.app";}
      {path = "/Applications/Xcode.app";}
      {path = "${pkgs.alacritty}/Applications/Alacritty.app";}
      {path = "/Applications/Fork.app";}
      {path = "/Applications/neovide.app";}
      {path = "/Applications/Logos.app";}
      {path = "/System/Applications/System\ Settings.app";}
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
