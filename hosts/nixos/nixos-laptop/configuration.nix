{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nixos-hardware.nixosModules.apple-t2
    ../common-configuration.nix
  ];
  hardware = {
    # for T2 MacBookPro16,1
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
  };

  boot = {
    extraModulePackages = [config.boot.kernelPackages.broadcom_sta];
  };

  networking.hostName = "nixos-laptop"; # Define your hostname.
}
