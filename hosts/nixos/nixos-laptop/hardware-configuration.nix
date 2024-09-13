# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = [
        "xhci_pci"
        "nvme"
        "usbhid"
        "usb_storage"
        "sd_mod"
      ];
      kernelModules = [];
      luks.devices."luks-f4e18b91-5cec-4b40-ac1e-5683056b4572".device = "/dev/disk/by-uuid/f4e18b91-5cec-4b40-ac1e-5683056b4572";
    };
    kernelModules = [
      "kvm-intel"
      "sg"
    ];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/8e7c7fb7-c89c-46e5-957a-f70e8f43ca23";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/47AC-5F88";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };

  swapDevices = [{device = "/dev/disk/by-uuid/3b1bc5d1-a381-417b-91ea-32ef568814b5";}];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
