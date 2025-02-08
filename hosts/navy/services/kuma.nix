{ ... }:
{
  services.uptime-kuma.enable = true;
  feline.caddy.routes = {
    "uptime.elia.garden".port = 3001;
    "monitor.feline.works".port = 3001;
    "monitor.catin.eu".port = 3001;
  };
  feline.persist.kuma.path = "/var/lib/uptime-kuma";
}
