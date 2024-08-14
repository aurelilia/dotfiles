{ ... }:
{
  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" = {
    device = "zroot/system/root";
    fsType = "zfs";
  };
  fileSystems."/nix" = {
    device = "zroot/system/store";
    fsType = "zfs";
  };
  fileSystems."/persist" = {
    device = "zroot/data/keep/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/var/lib/docker" = {
    device = "zroot/system/docker";
    fsType = "zfs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/64FD-A75F";
    fsType = "vfat";
  };

  boot.zfs = {
    requestEncryptionCredentials = [
      "zroot/data"
      "zmedia"
    ];
    extraPools = [
      "zbackup"
      "zmedia"
    ];
  };

  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "3c:ec:ef:ea:f4:67";
    linkConfig.Name = "lan";
  };
}
