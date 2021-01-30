# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [ ./hardware-configuration.nix ];

  fonts.fonts = with pkgs; [ nerdfonts ];

  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "daily";
      options = "--delete-older-than 3d";
    };
  };


  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixbox"; # Define your hostname.
  #networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;
  networking.nameservers = [
    "1.1.1.1"
    "1.0.0.1"
    "2606:4700:4700::1111"
    "2606:4700:4700::1001"
  ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n = {
  #   consoleFont = "Lat2-Terminus16";
  #   consoleKeyMap = "us";
  #   defaultLocale = "en_US.UTF-8";
  # };

  time.timeZone = "America/Indiana/Indianapolis";

  environment.systemPackages = with pkgs; [
    wget
    vim
    tmux
    htop
    zsh
    nixops
    clang
  ];

  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  programs.mosh = {
    enable = true;
  };

  services.openssh = {
    enable = true;
    forwardX11 = true;
  };

  networking.firewall.allowedTCPPorts = [
    22 # ssh
    2375 # docker
    2376 # docker
    27017 # mongodb
    3000 # gitea
    3306 # mariadb
    # 3333 # hydra
    3389 # xrdp
    5342 # postgres
    5601 # kibana
    8080
    8081
    8082
    8200
    9091
    9200 # elasticsearch
    51929
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.xrdp = {
    enable = true;
    defaultWindowManager = "${pkgs.xfce4-14.xfce4-session}/bin/xfce4-session";
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    layout = "us";

    xkbOptions = "caps:escape";

    # Enable touchpad support.
    #libinput.enable = true;
    desktopManager = {
      #xfce.enable = true;
      pantheon.enable = true;
    };
  };

  services.compton = {
    enable = true;
    fade = true;
    inactiveOpacity = 0.9;
    shadow = true;
    fadeDelta = 4;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.

  users.users.zach = {
    name = "zach";
    group = "users";
    createHome = true;
    home = "/home/zach";
    shell = "/run/current-system/sw/bin/zsh";
    uid = 1000;
    extraGroups = [
      "wheel"
      "transmission"
      "networkmanager"
      "docker"
    ];
  };

  users.users.redis = {
    group = "users";
    createHome = false;
    uid = 3000;
    extraGroups = [ "redis" ];
  };

  users.users.mysql = {
    createHome = false;
  };

  services.redis.enable = true;
  services.redis.openFirewall = true;
  services.redis.settings = {
    protected-mode = "no";
  };

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;

    extraOptions = ''
      plugin-load-add = auth_socket.so
      log-error = /var/log/mysql_err.log
    '';
  };

  services.mongodb = {
    enable = true;
    bind_ip = "0.0.0.0";
  };

  services.postgresql = {
    enable = true;
    enableTCPIP = true;
    ensureUsers = [
      {
        name = "zach";
        ensurePermissions = {
          "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
        };
      }
      #{
      #  name = "hydra";
      #  ensurePermissions = {
      #    "ALL TABLES IN SCHEMA public" = "ALL PRIVILEGES";
      #  };
      #}
    ];
  };

  nixpkgs.config.allowUnfree = true;

  services.gitea.enable = true;

  services.plex.enable = true;
  services.plex.openFirewall = true;

  services.transmission.enable = true;
  services.transmission.settings.rpc-whitelist = "192.168.*.* 127.0.0.1";

  services.lorri.enable = true;

  hardware.opengl.driSupport32Bit = true;

  services.vault = {
    enable = true;
    storageBackend = "file";
    address = "0.0.0.0:8200";
    extraConfig = "ui = true";
  };

  #services.hydra = {
  #  enable = true;
  #  hydraURL = "http://localhost:3333";
  #  port = 3333;
  #  listenHost = "*";
  #  notificationSender = "hydra@localhost";
  #  buildMachinesFiles = [ ];
  #  useSubstitutes = true;
  #};

  virtualisation.docker = {
    enable = true;
    autoPrune.enable = true;
    listenOptions = [
      "tcp://0.0.0.0:2375"
      "/run/docker.sock"
    ];
    extraOptions = "-H tcp://0.0.0.0:2375";
  };

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?

}
