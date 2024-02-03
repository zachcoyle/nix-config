# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-t2
  ];
  hardware = {
    # MacBookPro16,1
    enableAllFirmware = true;
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

    #services.xserver.videoDrivers = ["amdgpu-pro"];
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = [pkgs.amdvlk];
      extraPackages32 = [pkgs.driversi686Linux.amdvlk];
    };
  };

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
    kernelModules = ["wl"];
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
    blacklistedKernelModules = [
      #"b43"
      #"bcma"
      #"ssb"
      # "brcmfmac"
    ];
  };
  nixpkgs.config.allowUnfree = true;

  security.pam.services.swaylock = {};
  networking.hostName = "nixos-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "America/Indiana/Indianapolis";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  services = {
    xserver = {
      # console = {
      #   font = "Lat2-Terminus16";
      #   keyMap = "us";
      #   useXkbConfig = true; # use xkbOptions in tty.
      # };

      # Enable the X11 windowing system.
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = true;
          sugarCandyNix = {
            enable = true;
            settings = {
              #Background = ;
              ScreenWidth = 1920;
              ScreenHeight = 1080;
              FormPosition = "left";
              HaveFormBackground = true;
              PartialBlur = true;
            };
          };
        };
      };
      xkb.layout = "us";

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
    };
    printing.enable = true;
    pipewire = {
      enable = true;
      audio.enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
    };

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };
  };

  # Enable sound.
  sound.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.zcoyle = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "disk"
      "networkmanager"
      "input"
    ];
    packages = [];
  };
  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
      iwd
      wget
      alacritty
      git
      firefox
      libimobiledevice
      ifuse
      dmidecode
      lshw
      nyxt
      alejandra
      neofetch
      #xdg-desktop-portal-hyperland
      pciutils
      linuxKernel.packages.linux_zen.broadcom_sta
    ]; # Did you read the comment?
  };
  programs = {
    hyprland.enable = true;

    zsh.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };
  users.users.zcoyle.shell = pkgs.zsh;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05";
  stylix = {
    image = ../../../wallpapers/platform.jpg;
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    fonts = {
      serif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      sansSerif = {
        package = pkgs.fira;
        name = "Fira Sans";
      };
      monospace = {
        package = pkgs.fira-code-nerdfont;
        name = "Fira Code Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 12;
        desktop = 10;
        popups = 14;
        terminal = 10;
      };
    };
    opacity = {
      popups = 0.8;
      terminal = 0.8;
    };
    cursor = {
      name = "Bibata-Modern-Gruvbox";
      size = 24;
      package = pkgs.stdenvNoCC.mkDerivation {
        # TODO: package this properly
        pname = "bibata-cursors-gruvbox";
        version = "unstable";
        src = ../../../Bibata-Modern-Gruvbox;
        installPhase = ''
          mkdir -p $out/share/icons
          cp -r . $out/share/icons/Bibata-Modern-Gruvbox
        '';
      };
    };
    targets = {
      nixvim = {
        enable = false;
        transparent_bg = {
          main = true;
          sign_column = true;
        };
      };
    };
  };
}
