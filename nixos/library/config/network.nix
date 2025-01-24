{ name, lib, ... }:
{
  networking = {
    hostName = name;
    fqdn = name + ".elia.garden";

    useDHCP = lib.mkDefault true;
    firewall.enable = lib.mkDefault true;

    extraHosts = ''
      202.61.255.155 connectivitycheck.gstatic.com
      100.64.0.3      hazyboi hazyboi.elia.garden
      100.64.0.11     bengal bengal.elia.garden
      100.64.0.5      haze haze.elia.garden q.request.kitten.works s.request.kitten.works r.request.kitten.works p.request.kitten.works
      100.64.0.1      lowlander lowlander.elia.garden
      100.64.0.2      navy navy.elia.garden
    '';
  };
}
