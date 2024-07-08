{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  networking.hostName = "nixos-desktop";
  nix = {
    buildMachines = [
      {
        sshUser = "zcoyle";
        hostName = "nixos-laptop";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        maxJobs = 6;
        speedFactor = 1;
        supportedFeatures = [
          "nixos-test"
          "benchmark"
          "big-parallel"
          "kvm"
        ];
        mandatoryFeatures = [ ];
      }
    ];
    distributedBuilds = true;
  };

  services.fwupd.enable = true;
}
