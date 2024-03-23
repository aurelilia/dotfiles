{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ahci"
    "nvme"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [
    "kvm-intel"
    "nfs"
    "nfsd"
  ];
  boot.extraModulePackages = [ ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    mirroredBoots = [
      {
        devices = [ "nodev" ];
        path = "/boot";
      }
    ];
  };

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

  swapDevices = [ ];

  networking = {
    useDHCP = true;
    nameservers = [
      "192.168.0.100"
      "9.9.9.9"
    ];
  };
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "3c:ec:ef:ea:f4:67";
    linkConfig.Name = "lan";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
