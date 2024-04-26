{ name, lib, ... }:
{
  networking = {
    hostName = name;
    fqdn = name + ".elia.garden";
    firewall.enable = lib.mkDefault true;
    extraHosts = ''
      202.61.255.155 connectivitycheck.gstatic.com
    '';
  };
}
