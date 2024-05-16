# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];
  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "nvme" "usbhid"];
      kernelModules = [];
    };
    kernelModules = ["kvm-intel" "sg"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f6eabe6b-285d-4613-a169-2f2db91f7684";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/B169-C160";
      fsType = "vfat";
    };
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/0e8b42e5-cbf6-426e-a70e-9e084c42ca04";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
