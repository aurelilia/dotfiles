{ name, lib, ... }:
{
  networking = {
    hostName = name;
    fqdn = name + ".elia.garden";

    useDHCP = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;

    extraHosts = ''
      202.61.255.155 connectivitycheck.gstatic.com
    '';
  };
}
