{
  pkgs,
  lib,
  config,
  ...
}:
{
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
      "/share/xdg-desktop-portal"
      "/share/applications"
      "/share/nautilus-python/extensions"
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
    ];
  };

  programs = {

    adb.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    nautilus-open-any-terminal = {
      enable = true;
      terminal = "alacritty";
    };

    nh = {
      enable = true;
      clean = {
        enable = true;
        dates = "daily";
        extraArgs = "--keep-since 2d --keep 10"; # "--nogcroots"
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

    redis = {
      enable = true;
      package = pkgs.valkey;
      servers.default = {
        settings = {
          loadmodule = [ ];
        };
      };
    };

    udisks2.enable = true;

    udev.packages = [ pkgs.android-udev-rules ];

    upower.enable = true;

    usbmuxd = {
      enable = true;
      package = pkgs.usbmuxd2;
    };

  };

  stylix =
    (import ../../theme/stylix.nix { inherit pkgs; })
    // (import ../../theme/stylix-nixos.nix { inherit pkgs; });

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
