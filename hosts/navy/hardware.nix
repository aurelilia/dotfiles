{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];
  boot.supportedFilesystems = [ "btrfs" ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";

  boot.initrd.luks.devices.root = {
    device = "/dev/disk/by-uuid/2647b0a5-c397-4135-ac3a-21ae68931673";
    preLVM = true;
    allowDiscards = true;
  };
  fileSystems."/" = {
    device = "/dev/mapper/root";
    fsType = "btrfs";
    options = [
      "subvol=/"
      "compress=zstd"
      "noatime"
    ];
  };
  services.btrfs.autoScrub.enable = true;

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/bb655f53-a197-4b19-8afb-232b2946a600";
    fsType = "ext4";
  };

  swapDevices = [ { device = "/@swap/swapfile"; } ];

  networking = {
    useDHCP = false;
    nameservers = [ "9.9.9.9" ];
    defaultGateway = "202.61.252.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };

    interfaces.ens3 = {
      ipv6.addresses = [
        {
          address = "2a03:4000:55:f57::1";
          prefixLength = 64;
        }
      ];
      ipv4.addresses = [
        {
          address = "202.61.255.155";
          prefixLength = 22;
        }
      ];
    };
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
