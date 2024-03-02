{
  pkgs,
  lib,
  config,
  ...
}: {
  hardware = {
    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
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
      extraPackages32 = with pkgs.driversi686Linux; [
        amdvlk
      ];
    };
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "auto";
        configurationLimit = 120;
        netbootxyz.enable = true;
      };
      efi.canTouchEfiVariables = true;
    };
    plymouth.enable = true;
    kernelModules = ["wl"];
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  };

  nixpkgs.config.allowUnfree = true;

  security = {
    pam.services = {
      hyprlock = {};
    };
    doas = {
      enable = true;
      extraRules = [
        {
          users = ["zcoyle"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.
  time.timeZone = "America/Indiana/Indianapolis";
  i18n.defaultLocale = "en_US.UTF-8";

  sound.enable = true;

  environment = {
    # List packages installed in system profile. To search, run:
    # $ nix search wget
    sessionVariables.NIXOS_OZONE_WL = "1";
    systemPackages = with pkgs; [
      alacritty
      alejandra
      dmidecode
      firefox
      git
      ifuse
      iwd
      libimobiledevice
      linuxKernel.packages.linux_zen.broadcom_sta
      lshw
      neovim
      nyxt
      pciutils
      wget
    ];
  };

  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
    };

    zsh.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
  };

  console = {
    # font = "Lat2-Terminus16";
    # keyMap = "us";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  services = {
    blueman.enable = true;

    xserver = {
      #videoDrivers = ["amdgpu-pro"];
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
          enableHidpi = config.networking.hostName == "nixos-laptop";
          sugarCandyNix = {
            enable = true;
            settings = {
              Background = lib.cleanSource ../../users/zcoyle/dots/sddm-background.jpg;
              ScreenWidth = 1920;
              ScreenHeight = 1080;
              FormPosition = "left";
              HaveFormBackground = true;
              PartialBlur = true;
            };
          };
        };
      };

      xkb = {
        layout = "us, us";
        variant = ", colemak";
        options = "caps:escape,grp:alt_space_toggle,terminate:ctrl_alt_bksp";
      };

      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
        };
      };
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

    openssh.enable = true;

    ollama.enable = true;
  };

  stylix =
    (import ../../theme/stylix.nix {inherit pkgs;})
    // (import ../../theme/stylix-nixos.nix {inherit pkgs;});

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
          "wheel"
        ];
        packages = [];
        shell = pkgs.zsh;
      };
    };
  };

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

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
