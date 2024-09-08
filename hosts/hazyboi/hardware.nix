{ ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usbhid"
    "amdgpu"
    "r8169"
  ];
  boot.kernelModules = [
    "kvm-amd"
    "amdgpu"
    "r8169"
  ];

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
    device = "/dev/disk/by-uuid/0855-195B";
    fsType = "vfat";
  };

  boot.initrd.systemd.network.networks."10-lan" = {
    matchConfig.Name = "enp4s0";
    networkConfig = {
      DHCP = "ipv4";
      IPv6AcceptRA = false;
    };
    linkConfig.RequiredForOnline = "routable";
  };
  networking.nameservers = [
    "10.1.0.1"
    "9.9.9.9"
  ];
}
