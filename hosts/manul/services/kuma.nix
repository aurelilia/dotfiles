{ ... }:
{
  services.uptime-kuma.enable = true;
  feline.caddy.routes."monitor.catin.eu".port = 3001;
  feline.persist.kuma.path = "/var/lib/private/uptime-kuma";
}
