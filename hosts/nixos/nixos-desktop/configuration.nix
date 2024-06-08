{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];
  boot = {
    supportedFilesystems = ["bcachefs"];
    kernelPackages = pkgs.linuxPackages_latest;
  };
  networking.hostName = "nixos-desktop";
}
