{ lib, config, ... }:
{
  config = {
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.grub = {
      enable = true;
      efiSupport = config.feline.grub.enableEfi;
      mirroredBoots = lib.mkIf config.feline.grub.enableEfi [
        {
          devices = [ "nodev" ];
          path = "/boot";
        }
      ];
    };
  };

  options.feline.grub.enableEfi = lib.mkEnableOption "GRUB with EFI";
}
