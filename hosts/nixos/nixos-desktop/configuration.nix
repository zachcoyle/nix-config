{...}: {
  imports = [
    ./hardware-configuration.nix
    ../common-configuration.nix
  ];

  networking.hostName = "nixos-desktop";
}
