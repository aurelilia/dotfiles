{ ... }:
{
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
  ];
  boot.kernelModules = [ "kvm-intel" ];
}
