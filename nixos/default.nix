{
  config,
  lib,
  pkgs,
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

    # Misc
    zramSwap.enable = true;
    boot.supportedFilesystems = [ "ntfs" ];
    environment.systemPackages = [ pkgs.python3 ];
  };
}
