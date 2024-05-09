{
  pkgs,
  lib,
  inputs,
  ...
}: let
  tomlFormat = pkgs.formats.toml {};
in {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-t2
    ../common-configuration.nix
  ];
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

  networking.hostName = "nixos-laptop"; # Define your hostname.

  # https://nixos.wiki/wiki/Laptop

  powerManagement.enable = true;

  environment.etc."tiny-dfr/config.toml".source = lib.mkForce (tomlFormat.generate "config.toml" {
    # tiny-dfr config template. Do not edit this file directly, instead
    # copy it to /etc/tiny-dfr/config.toml and edit that copy.
    # The daemon will merge those two files, giving preference to the one in /etc

    # F{number} keys are shown when Fn is not pressed by default.
    # Set this to true if you want the media keys to be shown without Fn pressed
    MediaLayerDefault = true;

    # Set this to false if you want to hide the button outline,
    # leaving only the text/logo
    ShowButtonOutlines = true;

    # Set this to true to slowly shift the entire screen contents.
    # In theory this helps with screen longevity, but macos does not bother doing it
    # Disabling ShowButtonOutlines will make this effect less noticeable to the eye
    EnablePixelShift = false;

    # Set this to the fontconfig pattern to be used to pick a font for text labels
    # Some examples are:
    # "" - default regular sans-serif font
    # ":bold" - default bold sans-serif font
    # For full reference on accepted values see the fontconfig user guide,
    # section "Font Names"
    # https://www.freedesktop.org/software/fontconfig/fontconfig-user.html
    FontTemplate = ":bold";

    # Set this to false if you want the brightness of the touchbar
    # to be set to a static value instead of following the primary
    # screen's brightness
    AdaptiveBrightness = true;

    # With adaptive brightness disabled this is used as the brightness
    # in the active state
    # With it enabled, this is the maximum point on the brightness curve
    # Accepted values are 0-255
    ActiveBrightness = 128;

    # This key defines the contents of the primary layer
    # (the one with F{number} keys)
    # You can change the individual buttons, add, or remove them
    # Any number of keys that is greater than 0 is allowed
    # however rendering will start to break around 24 keys
    PrimaryLayerKeys = [
      # Action defines the key code to send when the button is pressed
      # Text defines the button label
      # Icon specifies the icon to be used for the button.
      # Icons can either be svgs or pngs, with svgs being preferred
      # For best results with pngs, they should be 48x48
      # Do not include the extension in the file name.
      # Icons are looked up in /etc/tiny-dfr first and then in /usr/share/tiny-dfr
      # Only one of Text or Icon is allowed,
      # if both are present, the behavior is undefined.
      # For the list of supported key codes see
      # https://docs.rs/input-linux/latest/input_linux/enum.Key.html
      {
        Text = "F1";
        Action = "F1";
      }
      {
        Text = "F2";
        Action = "F2";
      }
      {
        Text = "F3";
        Action = "F3";
      }
      {
        Text = "F4";
        Action = "F4";
      }
      {
        Text = "F5";
        Action = "F5";
      }
      {
        Text = "F6";
        Action = "F6";
      }
      {
        Text = "F7";
        Action = "F7";
      }
      {
        Text = "F8";
        Action = "F8";
      }
      {
        Text = "F9";
        Action = "F9";
      }
      {
        Text = "F10";
        Action = "F10";
      }
      {
        Text = "F11";
        Action = "F11";
      }
      {
        Text = "F12";
        Action = "F12";
      }
    ];

    # This key defines the contents of the media key layer
    MediaLayerKeys = [
      {
        Icon = "brightness_low";
        Action = "BrightnessDown";
      }
      {
        Icon = "brightness_high";
        Action = "BrightnessUp";
      }
      {
        Icon = "mic_off";
        Action = "MicMute";
      }
      {
        Icon = "search";
        Action = "Search";
      }
      {
        Icon = "backlight_low";
        Action = "IllumDown";
      }
      {
        Icon = "backlight_high";
        Action = "IllumUp";
      }
      {
        Icon = "fast_rewind";
        Action = "PreviousSong";
      }
      {
        Icon = "play_pause";
        Action = "PlayPause";
      }
      {
        Icon = "fast_forward";
        Action = "NextSong";
      }
      {
        Icon = "volume_off";
        Action = "Mute";
      }
      {
        Icon = "volume_down";
        Action = "VolumeDown";
      }
      {
        Icon = "volume_up";
        Action = "VolumeUp";
      }
    ];
  });

  services = {
    thermald.enable = true;

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
        CPU_ENERGY_PERF_POLICY_ON_AC = "performance";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 20;

        #Optional helps save long term battery health
        START_CHARGE_THRESH_BAT0 = 40; # 40 and below it starts to charge
        STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
      };
    };

    auto-cpufreq.enable = true;
    auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };
  };
}
