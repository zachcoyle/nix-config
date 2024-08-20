{
  pkgs,
  lib,
  config,
  ...
}:
let
  inherit (config.lib.stylix.colors) withHashtag;
in
{

  imports = [
    ../../theme/stylix.nix
    ../../theme/stylix-nixos.nix
  ];

  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages32 = with pkgs.driversi686Linux; [ amdvlk ];
      extraPackages = with pkgs; [
        amdvlk
        libva
        libvdpau-va-gl
        rocm-opencl-icd
        rocm-opencl-runtime
        rocmPackages.clr
        rocmPackages.clr.icd
        rocmPackages.hipblas
        rocmPackages.rocblas
        rocmPackages.rocm-comgr
        rocmPackages.rocm-runtime
        rocmPackages.rocm-smi
        rocmPackages.rocsolver
        rocmPackages.rocsparse
        vaapiVdpau
      ];
    };
  };

  boot = {
    extraModulePackages = [ config.boot.kernelPackages.broadcom_sta ];
    kernelModules = [ "wl" ];
    loader = {
      timeout = 1;
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 120;
        netbootxyz.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    supportedFilesystems = {
      bcachefs = true;
      exfat = true;
      ext4 = true;
      fat = true;
      zfs = lib.mkForce false;
    };
  };

  nixpkgs.config.allowUnfree = true;

  security = {
    pam = {
      yubico = {
        enable = true;
        debug = true;
        mode = "challenge-response";
        id = [
          "15732395"
          "15217433"
        ];
      };
      services = {
        greetd.enableGnomeKeyring = true;
        hyprlock = {
          yubicoAuth = true;
          u2fAuth = true;
        };
        login.u2fAuth = true;
        sudo.u2fAuth = true;
      };
    };
    doas = {
      enable = true;
      extraRules = [
        {
          users = [ "zcoyle" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  networking = {
    # proxy = {
    #   default = "http://user:password@proxy:port/";
    #   noProxy = "127.0.0.1,localhost,internal.domain";
    # };
    firewall = {
      allowedTCPPorts = [
        8080 # web dev
        8081 # web dev
      ];
      allowedUDPPorts = [ ];
    };
    nameservers = [
      # quad9
      "9.9.9.9"
      "149.112.112.112"
    ];
    networkmanager = {
      enable = true;
      plugins = [ ];
    };
  };

  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";

  environment = {
    sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${pkgs.nautilus-python}/lib/nautilus/extensions-4";
    pathsToLink = [
      "/share/applications"
      "/share/nautilus-python/extensions"
      "/share/xdg-desktop-portal"
      "/share/zsh"
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      alacritty
      alejandra
      dmidecode
      firefox-bin
      git
      nautilus
      nautilus-python
      ifuse
      iwd
      libimobiledevice
      lshw
      neovim
      pciutils
      virt-manager
      wget
      (bibata-hyprcursor.overrideAttrs (oldAttrs: {
        configurePhase =
          ''
            find cursors -type f -name '*.svg' | xargs sed -i \
              -e 's/#00FF00/${withHashtag.base00}/g' \
              -e 's/#2C2C2C/${withHashtag.base00}/g' \
              -e 's/black/${withHashtag.base00}/g' \
              -e 's/#FF0000/${withHashtag.base00}/g' \
              -e 's/#606060/${withHashtag.base03}/g' \
              -e 's/#0000FF/${withHashtag.base07}/g' \
              -e 's/white/${withHashtag.base07}/g' \
              -e 's/#F05024/${withHashtag.base08}/g' \
              -e 's/#FE0000/${withHashtag.base08}/g' \
              -e 's/#F1613A/${withHashtag.base09}/g' \
              -e 's/#F27400/${withHashtag.base09}/g' \
              -e 's/#FCB813/${withHashtag.base0A}/g' \
              -e 's/#FDBE2A/${withHashtag.base0A}/g' \
              -e 's/#06B231/${withHashtag.base0B}/g' \
              -e 's/#0A6857/${withHashtag.base0B}/g' \
              -e 's/#7EBA41/${withHashtag.base0B}/g' \
              -e 's/#96C865/${withHashtag.base0B}/g' \
              -e 's/#179DD8/${withHashtag.base0D}/g' \
              -e 's/#32A0DA/${withHashtag.base0D}/g' \
              -e 's/#4FADDF/${withHashtag.base0D}/g' \
              -e 's/#5F3BE4/${withHashtag.base0E}/g'
          ''
          + oldAttrs.configurePhase;
      }))
    ];
  };

  programs = {

    adb.enable = true;

    fish.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    mosh.enable = true;

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 2d --keep 10 --nogcroots";
      };
      flake = "/home/zcoyle/Developer/github.com/zachcoyle/nix-config";
    };

    yubikey-touch-detector.enable = true;

    zsh.enable = true;
  };

  console = {
    earlySetup = true;
    # keyMap = "us";
    useXkbConfig = true;
  };

  services = {

    avahi = {
      # bonjour!
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    blueman.enable = true;

    gnome.gnome-keyring.enable = true;

    greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${lib.getExe pkgs.greetd.tuigreet} --time --time-format '%I:%M %p | %a • %h | %F' --cmd Hyprland";
          user = "greeter";
        };
      };
    };

    libinput = {
      enable = true;
      touchpad = {
        disableWhileTyping = true;
      };
    };

    openssh.enable = true;

    ollama = {
      enable = true;
      acceleration = "rocm";
    };

    pcscd.enable = true;

    printing = {
      enable = true;
      listenAddresses = [ "*:631" ];
      allowFrom = [ "all" ];
      browsing = true;
      defaultShared = true;
      openFirewall = true;
      drivers = with pkgs; [
        canon-capt
        canon-cups-ufr2
        carps-cups
        gutenprint
        gutenprintBin
        hplip
        # hplipWithPlugin # unfree
        postscript-lexmark
        samsung-unified-linux-driver
        splix
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
        cnijfilter2
      ];
    };

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

    udisks2.enable = true;

    udev.packages = with pkgs; [
      android-udev-rules
      yubikey-personalization
    ];

    upower.enable = true;

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

  };

  system.stateVersion = "24.05";

  users = {
    users = {
      zcoyle = {
        isNormalUser = true;
        extraGroups = [
          "audio"
          "disk"
          "input"
          "networkmanager"
          "video"
          "kvm"
          "adbusers"
          "wheel"
        ];
        packages = [ ];
        shell = pkgs.zsh;
      };
    };
  };

  virtualisation.libvirtd.enable = true;

  zramSwap.enable = true;

}
