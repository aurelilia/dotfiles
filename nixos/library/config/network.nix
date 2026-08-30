{ name, lib, ... }:
{
  networking = {
    hostName = name;
    fqdn = name + ".catin.eu";

    useDHCP = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;

    extraHosts = ''
      202.61.255.155  connectivitycheck.gstatic.com
      100.64.0.1      hazyboi hazyboi.catin.eu
      100.64.0.6      bengal bengal.catin.eu
      100.64.0.3      haze haze.catin.eu home.catin.eu
      100.64.0.4      lowlander lowlander.catin.eu
      100.64.0.5      manul manul.catin.eu budget.catin.eu
    '';
  };
}
