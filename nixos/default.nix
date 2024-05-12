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
    fileSystems."/persist".neededForBoot = lib.mkDefault true;
    hardware = {
      enableRedistributableFirmware = lib.mkDefault true;
      cpu = {
        intel.updateMicrocode = lib.mkDefault true;
        amd.updateMicrocode = lib.mkDefault true;
      };
    };

    # Misc
    zramSwap.enable = true;
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.python3 ];
  };
}
