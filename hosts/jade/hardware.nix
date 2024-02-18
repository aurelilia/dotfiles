{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "ehci_pci"
    "ahci"
    "sd_mod"
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
    device = "zroot/keep/persist";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/22D9-D363";
    fsType = "vfat";
  };
  fileSystems."/backup" = {
    device = "zbackup/local";
    fsType = "zfs";
  };

  boot.zfs.extraPools = [ "zdata" ];
  swapDevices = [ ];

  networking = {
    useDHCP = false;
    defaultGateway = "10.0.0.1";
    nameservers = [
      "10.0.1.10"
      "9.9.9.9"
    ];
    interfaces.lan.ipv4.addresses = [
      {
        address = "10.0.1.1";
        prefixLength = 16;
      }
    ];
  };
  systemd.network.links."10-lan" = {
    matchConfig.PermanentMACAddress = "94:de:80:21:d2:08";
    linkConfig.Name = "lan";
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;
}
