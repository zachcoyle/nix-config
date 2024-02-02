# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  hardware = {
    # MacBookPro16,1
    enableAllFirmware = true;

    #services.xserver.videoDrivers = ["amdgpu-pro"];
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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

  networking.hostName = "nixos-desktop"; # Define your hostname.
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
              Background = lib.cleanSource ../../../dots/sddm-background.jpg;
              ScreenWidth = 1920;
              ScreenHeight = 1080;
              FormPosition = "left";
              HaveFormBackground = true;
              PartialBlur = true;
            };
          };
        };
      };
      layout = "us";

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
    extraGroups = ["wheel" "video" "audio" "disk" "networkmanager"];
    packages = with pkgs; [];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
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
    pciutils
    linuxKernel.packages.linux_zen.broadcom_sta
  ];
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };
    zsh.enable = true;
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
  system.stateVersion = "24.05"; # Did you read the comment?
  environment.etc = {
    "xdg/gtk-2.0/gtkrc".text = ''
      gtk-decoration-layout = appmenu:none
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme=Bibata-Modern-Gruvbox
      gtk-font-name="FiraCode Nerd Font"
    '';
    "xdg/gtk-3.0/settings.ini".text = ''
      [Settings]
      gtk-decoration-layout = appmenu:none
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme=Bibata-Modern-Gruvbox
      gtk-font-name="FiraCode Nerd Font"
    '';
    "xdg/gtk-4.0/settings.ini".text = ''
      [Settings]
      gtk-decoration-layout = appmenu:none
      gtk-application-prefer-dark-theme=1
      gtk-cursor-theme=Bibata-Modern-Gruvbox
      gtk-font-name="FiraCode Nerd Font"
    '';
  };
}
