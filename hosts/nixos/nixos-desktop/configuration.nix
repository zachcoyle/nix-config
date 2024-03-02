{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];
  boot = {
    supportedFilesystems = ["bcachefs"];
    kernelPackages = pkgs.linuxKernel.packages.linux_6_7;
  };
  networking.hostName = "nixos-desktop";
}
