{ ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
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
  fileSystems."/win" = {
    device = "/dev/disk/by-uuid/A0F40170F40149CC";
    fsType = "ntfs";
    options = [
      "uid=1000"
      "gid=1000"
    ];
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/69DB-CD68";
    fsType = "vfat";
  };

  networking.nameservers = [
    "192.168.0.100"
    "9.9.9.9"
  ];
}
