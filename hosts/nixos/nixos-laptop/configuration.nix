{
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
    apple-t2.enableAppleSetOsLoader = true;

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

  networking.hostName = "nixos-laptop"; # Define your hostname.
}
