{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "ahci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    zfsSupport = true;
    efiSupport = true;
    mirroredBoots = [{
      devices = [ "nodev" ];
      path = "/boot";
    }];
  };

  # TODO
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0066-697F";
    fsType = "vfat";
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/ede3da59-d13a-49fa-8b04-1caa1d0892bc"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
