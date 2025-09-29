{ modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
    "xen_blkfront"
    "vmw_pvscsi"
  ];
  boot.initrd.kernelModules = [ "nvme" ];
  boot.kernelParams = [ "boot.shell_on_fail" ];

  boot.initrd.supportedFilesystems = [ "zfs" ];
  boot.supportedFilesystems = [ "zfs" ];
  boot.zfs.requestEncryptionCredentials = [ "zroot" ];

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

  networking = {
    useDHCP = false;
    nameservers = [ "9.9.9.9" ];
    defaultGateway = "85.215.174.1";
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens6";
    };

    interfaces.ens6 = {
      ipv6.addresses = [
        {
          address = "2a01:239:41e:af00::1";
          prefixLength = 64;
        }
      ];
      ipv4.addresses = [
        {
          address = "85.215.174.234";
          prefixLength = 24;
        }
      ];
    };
  };
}
