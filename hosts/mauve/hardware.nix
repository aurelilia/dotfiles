{ ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
  ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" = {
    device = "zroot/system/root";
    fsType = "zfs";
  };
  fileSystems."/nix" = {
    device = "zroot/system/store";
    fsType = "zfs";
  };
  fileSystems."/persist" = {
    device = "zroot/keep/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0066-697F";
    fsType = "vfat";
  };

  swapDevices = [ { device = "/dev/disk/by-uuid/ede3da59-d13a-49fa-8b04-1caa1d0892bc"; } ];
}
