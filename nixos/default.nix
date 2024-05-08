{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./archetypes.nix
    ./backports
    ./library
    ./packages
  ];

  config = {
    # Locale
    time.timeZone = "Europe/Brussels";
    i18n.defaultLocale = "en_US.UTF-8";

    # Hardware defaults - x86_64 with EFI
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    feline.grub.enableEfi = lib.mkDefault true;
    hardware.cpu = {
      enableRedistributableFirmware = lib.mkDefault true;
      intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
      amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    };

    # Misc
    zramSwap.enable = true;
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.python3 ];
  };
}
