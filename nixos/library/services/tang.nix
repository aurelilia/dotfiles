{ config, lib, ... }:
{
  config = lib.mkIf config.feline.tang.enable {
    services.tang = {
      enable = true;
      ipAddressAllow = [
        "10.1.0.0/16"
        "100.64.0.0/24"
      ];
    };

    feline.persist."tang".path = "/var/lib/private/tang";
  };

  options.feline.tang.enable = lib.mkEnableOption "Tang keyserver";
}
