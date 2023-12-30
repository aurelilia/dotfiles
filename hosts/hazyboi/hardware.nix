{ config, lib, pkgs, modulesPath, ... }: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
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

  fileSystems."/" = {
    device = "zroot/root/nixos";
    fsType = "zfs";
  };
  fileSystems."/nix" = {
    device = "zroot/data/nix";
    fsType = "zfs";
  };
  fileSystems."/win" = {
    device = "/dev/disk/by-uuid/A0F40170F40149CC";
    fsType = "ntfs";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/69DB-CD68";
    fsType = "vfat";
  };
  fileSystems."/haze" = {
    device = "haze:/";
    fsType = "nfs4";
    options = [ "x-systemd.automount" "noauto" "x-systemd.idle-timeout=600" ];
  };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  networking.wireless.iwd.enable = true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
