{ lib, modulesPath, ... }:
{
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  boot.initrd.availableKernelModules = [
    "ahci"
    "xhci_pci"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  boot.kernelModules = [ "kvm-intel" ];

  feline.grub.enableEfi = false;
  boot.loader.grub.devices = [ "/dev/vda" ];
}
