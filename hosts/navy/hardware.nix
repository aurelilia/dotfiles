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

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
